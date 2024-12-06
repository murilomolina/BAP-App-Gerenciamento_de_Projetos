import 'package:bap_gerenciamento_projetos/blocs/bloc_login.dart';
import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:flutter/material.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.ofLoginUsuario(context);
    final azul = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: azul,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/logo/bap_logo.png',
                  width: 150, 
                ),
                // const SizedBox(height: 20),
                // const Text(
                //   'BAP Mobile',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //     fontSize: 40, 
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  // margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), 
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bem-vindo!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: azul,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Por favor, faça login para continuar',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _emailField(bloc!, azul),
                      _senhaField(bloc, azul),
                      const SizedBox(height: 20),
                      _loginButton(bloc, azul),
                      TextButton(onPressed: (){
                        _showRecoverPassword(context, bloc, azul);
                      }, 
                      child: const Text("Esqueci minha senha", style: TextStyle(decoration: TextDecoration.underline),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailField(LoginUsuarioBloc bloc, azul) {
    return StreamBuilder(
        stream: bloc.email,
        builder: (contex, AsyncSnapshot<String> snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              onChanged: bloc.changeEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'seu@email.com',
                labelText: 'e-mail',
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                filled: true,
                fillColor: Colors.grey[100],
                prefixIcon: Icon(Icons.email_outlined, color: azul),
              ),
            ),
          );
        });
  }

  Widget _senhaField(LoginUsuarioBloc bloc, azul) {
    // controla o estado de obscureText
    ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

    return StreamBuilder(
      stream: bloc.senha,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return TextField(
                onChanged: bloc.changeSenha,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: 'Senha',
                  labelText: 'Senha',
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: Icon(Icons.lock_outline, color: azul),
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
            }
          ),
        );
      },
    );
  }

  Widget _loginButton(LoginUsuarioBloc bloc, azul) {
    return StreamBuilder<bool>(
      stream: bloc.isLoading,
      builder: (context, AsyncSnapshot<bool> loadingSnapshot) {
        return StreamBuilder<bool>(
          stream: bloc.emailAndPassowrdAreOk,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return ElevatedButton(
              onPressed: snapshot.hasData && !(loadingSnapshot.data ?? false) ? () => bloc.login(context) : null,
              child: loadingSnapshot.data == true // Condição para mostrar o indicador ou o texto
                  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(azul))
                  : const Text('Logar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            );
          },
        );
      },
    );
  }

  void _showRecoverPassword(BuildContext context, LoginUsuarioBloc bloc, Color azul) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar senha'),
          content: FractionallySizedBox(
            heightFactor: 0.75, // Usa 75% da altura da tela
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Insira o seu e-mail e confirme a sua solicitação de recuperação.'),
                  const Text('Assim que for possível um Administrador entrará em contato com você.'),
                  const SizedBox(height: 10),
                  _emailField(bloc, azul),
                  const SizedBox(height: 5),
                  const Text('Se Precisar de mais ajuda entre em contato:'),
                  const SizedBox(height: 5),
                  const SelectableText('murilo.m.barone@gmail.com',style: TextStyle(color: Color.fromARGB(255, 114, 114, 114), fontSize: 16, decoration: TextDecoration.underline, fontStyle: FontStyle.italic),
              ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
              ),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
            _solicitaRecuperacao(bloc, azul),
          ],
        );
      },
    );
  }


  Widget _solicitaRecuperacao(LoginUsuarioBloc bloc, azul) {
    return StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => bloc.recover() : null,
          child: const Text(
            'Solicita Recuperação',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}