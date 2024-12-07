import 'package:bap_gerenciamento_projetos/blocs/bloc_usuario_app.dart';
import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Cardusuario extends StatelessWidget {
  final int idUsuario;
  final String nome;
  final String email;
  final String? linkFoto;
  final String telefone;
  final String senha;

  const Cardusuario({super.key, required this.idUsuario, required this.nome, required this.linkFoto, required this.telefone, required this.email, required this.senha});

  @override
  Widget build(BuildContext context) {
    EditaUsuarioBloc? bloc = Provider.ofEditaUsuario(context);
    CadastraUsuarioBloc? blocSuporte = Provider.ofCadastraUsuario(context);
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 157, 193, 255),
              Theme.of(context).primaryColor,
            ], // Gradiente de fundo
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(15), 
        ),
        width: 600,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            Text(
              email,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            // Text(
            //   linkFoto ?? '',
            //   style: const TextStyle(
            //     fontSize: 16, 
            //     color: Colors.black, 
            //   ),
            // ),
            Text(
              telefone,
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color: Colors.black, 
              ),
            ),
            // Botões de Editar e Excluir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showEditDialog(context, bloc!);
                  },
                ),
                IconButton(onPressed:() {
                  print(email);
                  _mailTo(email, context);
                }, icon: const Icon(Icons.email, color: Colors.white,)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    _showDeleteConfirmationDialog(blocSuporte!, context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, EditaUsuarioBloc bloc) {
  TextEditingController textoApoioNome = TextEditingController(text: nome);
  TextEditingController textoApoioEmail = TextEditingController(text: email);
  TextEditingController? textoApoioLinkFoto = TextEditingController(text: linkFoto);
  TextEditingController textoApoioTelefone = TextEditingController(text: telefone);
  TextEditingController textoApoioSenha = TextEditingController(text: senha);
  bloc.setInformacoes(nome, email, linkFoto ?? '', telefone, senha);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Altere todos os campos, nenhum campo pode estar vazio.'),
                _nomeField(bloc, textoApoioNome),
                _emailField(bloc, textoApoioEmail),
                _linkFotoField(bloc, textoApoioLinkFoto),
                _telefoneField(bloc, textoApoioTelefone),
                _senhaField(bloc, textoApoioSenha),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
            ),
            _editaButton(bloc, email),
          ],
        );
      },
    );
  }

  Widget _nomeField(EditaUsuarioBloc bloc, nome){
    return StreamBuilder(
      stream: bloc.nome,
      builder: (contex, AsyncSnapshot <String> snapshot){
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: nome,
            onChanged: (valorDigitado){
              bloc.changeNome(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: 'Nome do usuário',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.grey[100],),
          ),
        );
      });
  }

  Widget _emailField(EditaUsuarioBloc bloc, email){
    return StreamBuilder(
      stream: bloc.email,
      builder: (contex, AsyncSnapshot <String> snapshot){
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: email,
            onChanged: (valorDigitado){
              bloc.changeEmail(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: 'usuario@email.com',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.grey[100],),
          ),
        );
      });
  }

  Widget _senhaField(EditaUsuarioBloc bloc, TextEditingController senha) {
    // controla o estado de obscureText
    ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

    return StreamBuilder<String>(
      stream: bloc.senha,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return TextField(
                controller: senha,
                onChanged: (valorDigitado) {
                  bloc.changeSenha(valorDigitado);
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: "Edite a senha do usuario",
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Alterna a visibilidade e notifica os ouvintes
                      obscureTextNotifier.value = !obscureTextNotifier.value;
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _linkFotoField(EditaUsuarioBloc bloc, linkFoto) {
    return StreamBuilder(
      stream: bloc.linkFoto,
      builder: (context, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: linkFoto,
            onChanged: (valorDigitado){
              bloc.changeLinkFoto(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: "Link da foto de perfil",
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.grey[100],),
          ),
        );
      });
  }

  Widget _telefoneField(EditaUsuarioBloc bloc, telefone) {
    return StreamBuilder(
      stream: bloc.telefone,
      builder: (context, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            controller: telefone,
            onChanged: (valorDigitado){
              bloc.changeTelefone(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: "Telefone",
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                filled: true,
                fillColor: Colors.grey[100],),
          ),
        );
      });
  }

  Widget _editaButton(EditaUsuarioBloc bloc, emailSemAlteracao) {
    return StreamBuilder<bool>(
      stream: bloc.camposEditaAreOk,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => {bloc.editaUsuario(emailSemAlteracao), Navigator.of(context).pop()} : null, // Passando o contexto aqui
          child: const Text('Salvar'),
        );
      },
    );
  }

  Future<void> _mailTo(String email, context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject', 
    );
    try{
      await launchUrl(params);
    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o e-mail.'),
          duration: Duration(seconds: 3),
        ),
      );
      Fluttertoast.showToast(msg: '$e');
    }
  }

  void _showDeleteConfirmationDialog(CadastraUsuarioBloc bloc, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir este usuário? $email'),
          actions: [
            _deletaButton(bloc, idUsuario),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Widget _deletaButton(CadastraUsuarioBloc bloc, int idUsuario) {  
    return ElevatedButton(
      onPressed: () {bloc.deleteUser(idUsuario);} , // Passando o contexto aqui
      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
      child: const Text('Excluir'),
    );
  }
}