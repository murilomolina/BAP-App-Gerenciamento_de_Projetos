import 'package:bap_gerenciamento_projetos/blocs/bloc_contato.dart';
import 'package:bap_gerenciamento_projetos/blocs/bloc_usuario_app.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget{

  final blocLoginUsuario = LoginUsuarioBloc();
  final blocCadastraUsuario = CadastraUsuarioBloc();
  final blocEditaUsuario = EditaUsuarioBloc();

  final blocCadastraContato = CadastraContatoBloc();

  // Método para acessar o bloc de Login
  static LoginUsuarioBloc? ofLoginUsuario(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.blocLoginUsuario;
  }
  static CadastraUsuarioBloc? ofCadastraUsuario(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.blocCadastraUsuario;
  }
  static EditaUsuarioBloc? ofEditaUsuario(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.blocEditaUsuario;
  }

  // Métodos para acessar o bloc de Contato
  static CadastraContatoBloc? ofCadastraContato(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.blocCadastraContato;
  }


  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
    
  }
  Provider({super.key, required super.child});


}