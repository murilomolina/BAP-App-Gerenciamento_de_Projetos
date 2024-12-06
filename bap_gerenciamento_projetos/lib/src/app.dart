import 'package:bap_gerenciamento_projetos/pages/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const azulBap = Color.fromRGBO(34, 52, 110, 1);
    return MaterialApp(
      title: 'BAP - Gerenciamento de projetos',
      theme: ThemeData(
        primaryColor: azulBap, // Cor principal
        scaffoldBackgroundColor: Colors.white, // Cor de fundo do Scaffold
        // Padronização da Appbar em todas as páginas
        appBarTheme: const AppBarTheme(
          color: azulBap, // Cor da AppBar
          iconTheme: IconThemeData(color: Colors.white), // Cor dos ícones na AppBar
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 16.0) 
        ),
        // padronização de todos os elevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData( 
          style: ElevatedButton.styleFrom(
            backgroundColor: azulBap, // Cor padrão dos botões
            foregroundColor: Colors.white, // Cor do texto
            shadowColor: Colors.grey
          ),
        ),
        // padronização do drawer
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white, // Cor de fundo do drawer
          elevation: 5, // Sombra do drawer
          scrimColor: Colors.black54, // Cor da sombra atrás do drawer
        ),
        // Definir a fonte padrão aqui
        fontFamily: 'Roboto', // próxima a padrão (helvetica)
        
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

