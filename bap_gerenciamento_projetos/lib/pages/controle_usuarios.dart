import 'package:bap_gerenciamento_projetos/blocs/bloc_usuario_app.dart';
import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:bap_gerenciamento_projetos/classes/card_usuario.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:bap_gerenciamento_projetos/data/usuarioAPP/operacoes_usuario.dart';
import 'package:flutter/material.dart';


class ControleUsuarios extends StatelessWidget {
  const ControleUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.ofCadastraUsuario(context);
    final refreshKeyNotifier = ValueNotifier(UniqueKey());
    final searchController = TextEditingController();
    final searchNotifier = ValueNotifier<String>("");

    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _botaoRefresh(context, refreshKeyNotifier),
          const SizedBox(height: 20,),
          _botaoAdd(context, bloc!),
        ],
      ),
      drawer: const CustomDrawer(pagType: 1),
      body: Column(
        children: [
          // Campo de busca/filtro
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar/Filtrar usuário',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                searchNotifier.value = value.toLowerCase(); // Atualiza o filtro
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Key>(
              valueListenable: refreshKeyNotifier,
              builder: (context, key, _) {
                return ValueListenableBuilder<String>(
                  valueListenable: searchNotifier,
                  builder: (context, searchQuery, _) {
                    return FutureBuilder<List<UsuarioApp>>(
                      key: key,
                      future: consultaUsuariosApp(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Erro: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Nenhum usuário encontrado.'));
                        } else {
                          // Filtra a lista de usuários com base no valor de pesquisa
                          final usuarios = snapshot.data!
                              .where((usuario) =>
                                  usuario.nome.toLowerCase().contains(searchQuery) ||
                                  usuario.email.toLowerCase().contains(searchQuery) ||
                                  usuario.telefone.toLowerCase().contains(searchQuery))
                              .toList();
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Wrap(
                                    spacing: 40.0,
                                    runSpacing: 40.0,
                                    children: usuarios.map((usuario) {
                                      return Cardusuario(
                                        idUsuario: usuario.idUsuario,
                                        nome: usuario.nome,
                                        email: usuario.email,
                                        linkFoto: usuario.linkFoto,
                                        telefone: usuario.telefone,
                                        senha: usuario.senha,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoRefresh(BuildContext context, ValueNotifier<Key> refreshKeyNotifier) {
    return ElevatedButton(
      onPressed: () {
        refreshKeyNotifier.value = UniqueKey(); 
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(15),
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 10,
      ),
      child: const Icon(
        Icons.refresh,
        size: 30,
        color: Colors.white,
      ),
    );
  }
  Widget _botaoAdd(context, CadastraUsuarioBloc bloc){
    return ElevatedButton(
      onPressed: () {
        _showAddUserDialog(context, bloc);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), 
        padding: const EdgeInsets.all(15), 
        backgroundColor: Theme.of(context).primaryColor, 
        shadowColor: Colors.black.withOpacity(0.3), 
        elevation: 10, 
      ),
      child: const Icon(
        Icons.add, 
        size: 30, 
        color: Colors.white, 
      ),
    );
  }
  
  // Método para mostrar o diálogo de adição de usuário
  void _showAddUserDialog(BuildContext context, CadastraUsuarioBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Usuário'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _nomeField(bloc),
                _emailField(bloc),
                _linkFotoField(bloc),
                _telefoneField(bloc),
                _senhaField(bloc),
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
            _cadastraButton(bloc),
          ],
        );
      },
    );
  }

  Widget _nomeField(CadastraUsuarioBloc bloc) {
    return StreamBuilder(
      stream: bloc.nome,
      builder: (contex, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            onChanged: (valorDigitado){
              bloc.changeNome(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: 'Nome Sobrenome',
                labelText: 'Insira o nome do usuário',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                filled: true),
          ),
        );
      });
  }

  Widget _emailField(CadastraUsuarioBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (contex, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            onChanged: (valorDigitado){
              bloc.changeEmail(valorDigitado);
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'usuario@email.com',
                labelText: 'Insira e-mail do usuário',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                filled: true),
          ),
        );
      });
  }

  Widget _senhaField(CadastraUsuarioBloc bloc) {
    // controla o estado de obscureText
    ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(true);

    return StreamBuilder(
      stream: bloc.senha,
      builder: (context, AsyncSnapshot <String> snapshot){
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child){
              return TextField(
                onChanged: (valorDigitado) {
                  bloc.changeSenha(valorDigitado);
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                    hintText: 'Senha',
                    labelText: 'Digite a senha do usuário',
                    errorText: snapshot.hasError? snapshot.error.toString(): null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Alterna a visibilidade e notifica os ouvintes
                      obscureTextNotifier.value = !obscureTextNotifier.value;
                    },
                  ),),
              );
            }
          ),
        );
      }
    );
  }

  Widget _linkFotoField(CadastraUsuarioBloc bloc) {
    return StreamBuilder(
      stream: bloc.linkFoto,
      builder: (contex, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            onChanged: (valorDigitado){
              bloc.changeLinkFoto(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: 'Dica: use o link da foto de perfil do Facebook',
                labelText: 'Insira o link da foto de perfil',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                filled: true),
          ),
        );
      });
  }

  Widget _telefoneField(CadastraUsuarioBloc bloc) {
    return StreamBuilder(
      stream: bloc.telefone,
      builder: (contex, AsyncSnapshot <String> snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextField(
            onChanged: (valorDigitado){
              bloc.changeTelefone(valorDigitado);
            },
            decoration: InputDecoration(
                hintText: 'Sem parentêses e sem traços',
                labelText: 'Insira o telefone do usuário',
                errorText: snapshot.hasError? snapshot.error.toString(): null, 
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                filled: true),
          ),
        );
      });
  }

  Widget _cadastraButton(CadastraUsuarioBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.camposCadastroAreOk,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => bloc.cadastraUsuario() : null, // Passando o contexto aqui
          child: const Text('cadastrar'),
        );
      },
    );
  }
}