import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';


class PerfilLogado extends StatelessWidget {
  const PerfilLogado({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.ofLoginUsuario(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Avatar com sombra e borda aprimorada
                  CircleAvatar(
                    backgroundImage:NetworkImage(bloc!.linkFoto!) ,
                    foregroundImage:NetworkImage(bloc.linkFoto!),
                    radius: 75,
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: Color.fromARGB(255, 218, 218, 218),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Título do perfil
                  Text(
                    bloc.nome ?? 'Nome não disponível',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),                  
                  const SizedBox(height: 30),
                  // Container de informações
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email
                        _buildInfo(bloc.emailString, '', Icons.email, context),
                        // const Divider(
                        //   thickness: 1.2,
                        //   color: Colors.grey,
                        //   indent: 15,
                        //   endIndent: 15,
                        // ),
                        // Senha
                        const SizedBox(height: 15),
                        _buildInfo(bloc.senhaString, 'Senha:', Icons.lock, context),
                        const SizedBox(height: 15),
                        // Ocupação 
                        _buildInfo(bloc.telefone, 'Telefone:', Icons.phone, context),
                      ],
                    ),
                  ),
                  const Text('Caso alguma informação tenha sido alterada recentemente pode ser que haja alguma inconsistencia, portanto faça o logout e o login novamente.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey), textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Método para construir informações com ícones, espaçamento e estilo aprimorado
  Widget _buildInfo(String? campo, String label, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '$label ${campo ?? "Não disponível"}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
