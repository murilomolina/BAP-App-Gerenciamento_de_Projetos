import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:bap_gerenciamento_projetos/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
void main() async {
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("Erro ao carregar o arquivo .env: $e");
  }
  runApp(Provider(child: const App()));
}


