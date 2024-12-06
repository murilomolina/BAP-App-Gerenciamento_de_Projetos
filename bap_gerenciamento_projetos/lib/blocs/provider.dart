import 'package:bap_gerenciamento_projetos/blocs/bloc_login.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget{

  final blocLoginUsuario = LoginUsuarioBloc();
  

  // Método para acessar o bloc de Login
  static LoginUsuarioBloc? ofLoginUsuario(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()?.blocLoginUsuario;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
    
  }
  Provider({super.key, required super.child});


}