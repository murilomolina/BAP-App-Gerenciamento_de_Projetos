import 'package:bap_gerenciamento_projetos/data/usuarioAPP/auth_service.dart';
import 'package:bap_gerenciamento_projetos/data/usuarioAPP/operacoes_usuario.dart';
import 'package:bap_gerenciamento_projetos/pages/home_page.dart';
import 'package:bap_gerenciamento_projetos/pages/login_page.dart';
import 'package:bap_gerenciamento_projetos/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginUsuarioBloc with Validators{
  var _emailController = BehaviorSubject <String> ();
  var _senhaController = BehaviorSubject <String> ();
  final _isLoadingController = BehaviorSubject <bool>(); // esse controller é o responsavel pelo indicador de carregamento na tela de login!
  final AuthService _authService = AuthService(); // Instância do serviço de autenticação

  // Variáveis para armazenar dados do usuário autenticado
  int? _idUsuario;
  String? _nome;
  String? _email; // o email e a senha já são "pegos" nos controllers
  String? _linkFoto;
  String? _telefone;
  String? _senha; // porem em alguns casos é mais facil "pega-los" já como string por isso deixei eles aqui tamebm

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get senha => _senhaController.stream.transform(validateSenha);
  
  // Getter para acessar dados do usuário
  int? get idUsuario => _idUsuario;
  String? get nome => _nome;
  String? get emailString => _email;
  String? get linkFoto => _linkFoto;
  String? get telefone => _telefone;
  String? get senhaString => _senha;

  Stream<bool> get isLoading => _isLoadingController.stream;

  // Stream responsavel por exibir o botão de login
  Stream<bool> get emailAndPassowrdAreOk => CombineLatestStream.combine2(email, senha, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changeSenha => _senhaController.sink.add;

  Function(bool) get changeIsLoading => _isLoadingController.sink.add;
  
  void login(BuildContext context) async{
    // Inicia o carregamento
    _isLoadingController.add(true);

    final email = _emailController.value;
    final senha = _senhaController.value;

    // Chama o método de autenticação do AuthService
    final bool isAuthenticated = await _authService.autenticaUsuario(email, senha);

    // Finaliza o carregamento
    _isLoadingController.add(false);

    if (isAuthenticated) {
      // Busca os dados do usuário no banco
      final userData = await _authService.getUserData(email, senha);
      if (userData != null) {
        // Armazena os dados do usuário nas variáveis do BLoC
        _nome = userData['nome'];
        _email = userData['email'];
        _linkFoto = userData['link_foto'];
        _telefone = userData['telefone'];
        _senha = userData['senha'];
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      Fluttertoast.showToast(msg: 'E-mail: $email' + '\n' + 'Senha: $senha' + '\n',timeInSecForIosWeb: 5);
    } else {
      // Exibe uma mensagem de erro se a autenticação falhar
      Fluttertoast.showToast(msg: 'Credenciais inválidas. Tente novamente.', timeInSecForIosWeb: 5, backgroundColor: Colors.red, webBgColor: "linear-gradient(to right, #ff5f6d, #ff5f6d)");
    }
  }
  

  void logout(BuildContext context) async {
    await _authService.logout(); // Executa o logout do serviço de autenticação
    // Limpa os valores de email e senha ao deslogar
    resetControllers();
    Fluttertoast.showToast(msg: 'Deslogado com sucesso!');

    // Redireciona para a página de login, removendo todas as rotas anteriores
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()), 
      (Route<dynamic> route) => false,
    );

  }

  // metodo de recuperar senha (utilizado na tela de login)
  void recover() async{
    final email = _emailController.value;

    // Chama o método de autenticação do AuthService
    final bool emailCadastrado = await _authService.verificaEmail(email);

    if (emailCadastrado) {
      Fluttertoast.showToast(msg: 'Seu e-mail foi inserido corretamente, estamos entrando em contato com o responsavel',timeInSecForIosWeb: 5);
      resetControllers();
    } else {
      // Exibe uma mensagem de erro se a autenticação falhar
      Fluttertoast.showToast(msg: 'Email não cadastrado previamente. Tente novamente.', timeInSecForIosWeb: 5, backgroundColor: Colors.red, webBgColor: "linear-gradient(to right, #ff5f6d, #ff5f6d)");
    }
  }
  void resetControllers(){
    _emailController = BehaviorSubject<String>();
    _senhaController = BehaviorSubject<String>();
  }

  void dispose() {
    _emailController.close();
    _senhaController.close();
    _isLoadingController.close();
  }
}

class CadastraUsuarioBloc with Validators{
  var _nomeController = BehaviorSubject <String> ();
  var _emailController = BehaviorSubject <String> ();
  var _linkFotoController = BehaviorSubject <String?> ();
  var _telefoneController = BehaviorSubject <String> ();
  var _senhaController = BehaviorSubject <String> ();

  Stream<String> get nome => _nomeController.stream.transform(validateCampo); // por enquanto deixei a validação apenas de campo obrigatório

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get linkFoto => _linkFotoController.stream.map((value) => value ?? '').transform(validateCampoLinkFoto);

  Stream<String> get telefone => _telefoneController.stream.transform(validateTelefone);

  Stream<String> get senha => _senhaController.stream.transform(validateSenha);

  // Stream responsavel por exibir o botão de salvar
  // o link da foto não é obrigatório
  Stream<bool> get camposCadastroAreOk => CombineLatestStream.combine4(nome , email, telefone, senha, (n, e, t, s) => true);

  Function(String) get changeNome => _nomeController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changeLinkFoto => _linkFotoController.sink.add;

  Function(String) get changeTelefone => _telefoneController.sink.add;
  
  Function(String) get changeSenha => _senhaController.sink.add;


  void cadastraUsuario(){
    final nome = _nomeController.value;
    final email = _emailController.value;
    final linkFoto = _linkFotoController.valueOrNull;
    final telefone = _telefoneController.value;
    final senha = _senhaController.value;
    
    print('$nome, $email, $linkFoto, $telefone, $senha');
    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty && telefone.isNotEmpty) {
      inserirUsuario(nome, email, linkFoto ?? '', telefone, senha);
      Fluttertoast.showToast(msg: 'Cadastrado com sucesso!');
      _resetControllers();
    } else{
      Fluttertoast.showToast(msg: 'Preencha todos os campos!');
    }
  }

  // método para deletar
  void deleteUser(int idUsuario) {
    print(idUsuario);
    deletaUsuario(idUsuario);
    Fluttertoast.showToast(msg: 'Deletado com sucesso!');
  }

  void _resetControllers() {
    _nomeController = BehaviorSubject<String>();
    _emailController = BehaviorSubject<String>();
    _linkFotoController = BehaviorSubject<String?>();
    _telefoneController = BehaviorSubject<String>();
    _senhaController = BehaviorSubject<String>();
  }

  void dispose() {
    _nomeController.close();
    _emailController.close();
    _linkFotoController.close();
    _telefoneController.close();
    _senhaController.close();
  }
}

class EditaUsuarioBloc with Validators{
  var _nomeController = BehaviorSubject <String> ();
  var _emailController = BehaviorSubject <String> ();
  var _linkFotoController = BehaviorSubject <String?> ();
  var _telefoneController = BehaviorSubject <String> ();
  var _senhaController = BehaviorSubject <String> ();

  Stream<String> get nome => _nomeController.stream.transform(validateCampo); // por enquanto deixei a validação apenas de campo obrigatório

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  Stream<String> get linkFoto => _linkFotoController.stream.map((value) => value ?? '').transform(validateCampoLinkFoto);

  Stream<String> get telefone => _telefoneController.stream.transform(validateTelefone);

  Stream<String> get senha => _senhaController.stream.transform(validateSenha);

  // Função para preencher os campos com as informações atuais
  void setInformacoes(String nome, String email, String? linkFoto, String telefone, String senha) {
    _nomeController.add(nome);
    _emailController.add(email);
    _linkFotoController.add(linkFoto ?? '');
    _telefoneController.add(telefone);
    _senhaController.add(senha);
  }

  // Stream responsavel por exibir o botão de salvar
  // o link da foto nao é obrigatório
  Stream<bool> get camposEditaAreOk => CombineLatestStream.combine4(nome, email, telefone, senha, (n, e, t, s) => true);

  Function(String) get changeNome => _nomeController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changeLinkFoto => _linkFotoController.sink.add;

  Function(String) get changeTelefone => _telefoneController.sink.add;

  Function(String) get changeSenha => _senhaController.sink.add;

  void editaUsuario(emailSemAlteracao) async {
    final nome = _nomeController.value;
    final email = _emailController.value;
    final linkFoto = _linkFotoController.valueOrNull;
    final telefone = _telefoneController.value;
    final senha = _senhaController.value;
    
    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty && telefone.isNotEmpty) {  
      int userId = await achaUserID(emailSemAlteracao);

      print('$userId, $nome, $email, $linkFoto, $telefone, $senha');

      editarUsuario(userId, nome, email, linkFoto ?? '', telefone, senha);
      _resetControllers();
      Fluttertoast.showToast(msg: 'Editado com sucesso!');
    } else{
      Fluttertoast.showToast(msg: 'Preencha todos os campos!');
    }
  }

  void _resetControllers() {
    _nomeController = BehaviorSubject<String>();
    _emailController = BehaviorSubject<String>();
    _linkFotoController = BehaviorSubject<String?>();
    _telefoneController = BehaviorSubject<String>();
    _senhaController = BehaviorSubject<String>();
  }

  void dispose(){
    _nomeController.close();
    _emailController.close();
    _linkFotoController.close();
    _telefoneController.close();
    _senhaController.close();
  }
}