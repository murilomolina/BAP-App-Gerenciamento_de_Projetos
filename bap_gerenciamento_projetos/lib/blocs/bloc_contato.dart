import 'package:bap_gerenciamento_projetos/data/contatos/operacoes_contato.dart';
import 'package:bap_gerenciamento_projetos/validators/validators.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class CadastraContatoBloc with Validators{ 
  var _pertenceUsuarioController = BehaviorSubject<int>();
  var _nomeController = BehaviorSubject <String> ();
  var _emailController = BehaviorSubject <String?> ();
  var _telefoneController = BehaviorSubject <String> ();
  var _cpfController = BehaviorSubject <String?> ();
  var _rgController = BehaviorSubject <String?> ();
  var _chavePixController = BehaviorSubject <String?> ();
  var _enderecoRuaController = BehaviorSubject <String?> ();
  var _enderecoNumeroController = BehaviorSubject <String?> ();
  var _enderecoBairroController = BehaviorSubject <String?> ();
  var _enderecoCidadeController = BehaviorSubject <String?> ();
  var _enderecoCEPController = BehaviorSubject <String?> ();
  var _enderecoObservacoesController = BehaviorSubject <String?> ();

  void setPertenceUsuario(int pertenceUsuarioForaBloc){
    _pertenceUsuarioController.add(pertenceUsuarioForaBloc);
  }

  Stream<String> get nome => _nomeController.stream.transform(validateCampo); 

  Stream<String> get email => _emailController.map((value) => value ?? '').transform(validateEmail);

  Stream<String> get telefone => _telefoneController.stream.transform(validateTelefone);

  Stream<String> get cpf => _cpfController.map((value) => value ?? '').transform(validateCPF);

  Stream<String> get rg => _rgController.map((value) => value ?? '').transform(validateRG);

  Stream<String> get chavePix => _chavePixController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoRua => _enderecoRuaController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoNumero => _enderecoNumeroController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoBairro => _enderecoBairroController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoCidade => _enderecoCidadeController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoCEP => _enderecoCEPController.map((value) => value ?? '').transform(validateCampo);

  Stream<String> get enderecoObservacoes => _enderecoObservacoesController.map((value) => value ?? '').transform(validateCampo);

  // Stream responsavel por exibir o botão de salvar
  Stream<bool> get camposCadastroAreOk => CombineLatestStream.combine2(nome , telefone, (n, t) => true);

  Function(String) get changeNome => _nomeController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changeTelefone => _telefoneController.sink.add;

  Function(String) get changeCpf => _cpfController.sink.add;
  
  Function(String) get changeRg => _rgController.sink.add;

  Function(String) get changeChavePix => _chavePixController.sink.add;

  Function(String) get changeEnderecoRua => _enderecoRuaController.sink.add;

  Function(String) get changeEnderecoNumero => _enderecoNumeroController.sink.add;

  Function(String) get changeEnderecoBairro => _enderecoBairroController.sink.add;

  Function(String) get changeEnderecoCidade => _enderecoCidadeController.sink.add;

  Function(String) get changeEnderecoCEP => _enderecoCEPController.sink.add;

  Function(String) get changeEnderecoObservacoes => _enderecoObservacoesController.sink.add;

  void cadastraContato() async {
    final pertenceUsuario = _pertenceUsuarioController.value;
    final nome = _nomeController.value;
    final email = _emailController.valueOrNull;
    final telefone = _telefoneController.value;
    final cpf = _cpfController.valueOrNull;
    final rg = _rgController.valueOrNull;
    final chavePix = _chavePixController.valueOrNull;
    final enderecoRua = _enderecoRuaController.valueOrNull;
    final enderecoNumero = _enderecoNumeroController.valueOrNull;
    final enderecoBairro = _enderecoBairroController.valueOrNull;
    final enderecoCidade = _enderecoCidadeController.valueOrNull;
    final enderecoCEP = _enderecoCEPController.valueOrNull;
    final enderecoObservacoes = _enderecoObservacoesController.valueOrNull;
    
    if (nome.isNotEmpty && telefone.isNotEmpty)  {
      await cadastrarContato(pertenceUsuario, nome, email, telefone, cpf, rg, chavePix, enderecoRua, enderecoNumero, enderecoBairro, enderecoCidade, enderecoCEP, enderecoObservacoes);
      Fluttertoast.showToast(msg: 'Cadastrado com sucesso!');
      _resetControllers();
    } else{
      Fluttertoast.showToast(msg: 'Preencha todos os campos!');
    }
  }

  void limpaCampos() {
    changeNome('');
    changeEmail('');
    changeTelefone('');
    changeCpf('');
    changeRg('');
    changeChavePix('');
    changeEnderecoRua('');
    changeEnderecoNumero('');
    changeEnderecoBairro('');
    changeEnderecoCidade('');
    changeEnderecoCEP('');
    changeEnderecoObservacoes('');
    _resetControllers();
  }

  // método para deletar
  void deleteContato(int idContato) {
    print(idContato);
    excluirContato(idContato);
    Fluttertoast.showToast(msg: 'Deletado com sucesso!');
  }

  void _resetControllers() {
    _pertenceUsuarioController = BehaviorSubject <int>();
    _nomeController = BehaviorSubject <String> ();
    _emailController = BehaviorSubject <String?> ();
    _telefoneController = BehaviorSubject <String> ();
    _cpfController = BehaviorSubject <String?> ();
    _rgController = BehaviorSubject <String?> ();
    _chavePixController = BehaviorSubject <String?> ();
    _enderecoRuaController = BehaviorSubject <String?> ();
    _enderecoNumeroController = BehaviorSubject <String?> ();
    _enderecoBairroController = BehaviorSubject <String?> ();
    _enderecoCidadeController = BehaviorSubject <String?> ();
    _enderecoCEPController = BehaviorSubject <String?> ();
    _enderecoObservacoesController = BehaviorSubject <String?> ();
  }

  void dispose() {
    _pertenceUsuarioController.close();
    _nomeController.close();
    _emailController.close();
    _telefoneController.close();
    _cpfController.close();
    _rgController.close();
    _chavePixController.close();
    _enderecoRuaController.close();
    _enderecoNumeroController.close();
    _enderecoBairroController.close();
    _enderecoCidadeController.close();
    _enderecoCEPController.close();
    _enderecoObservacoesController.close();
  }
}