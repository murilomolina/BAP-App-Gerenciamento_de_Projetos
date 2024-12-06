import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Modelo de dados de usuário
class UsuarioApp {
  int idUsuario;
  String nome;
  String email;
  String linkFoto;
  String telefone;
  String senha;

  // Construtor
  UsuarioApp({
    required this.idUsuario,
    required this.nome,
    required this.email,
    required this.linkFoto,
    required this.telefone,
    required this.senha,
  });
  
  // Método para criar uma instância de UsuarioApp a partir de um Map (JSON)
  factory UsuarioApp.fromJson(Map<String, dynamic> json) {
    return UsuarioApp(
      idUsuario: json['id_usuario'],
      nome: json['nome'],
      email: json['email'],
      linkFoto: json['link_foto'],
      telefone: json['telefone'],
      senha: json['senha'],
    );
  }
}

// URL do servidor (substitua pelo IP e porta configurados)
var serverUrl = 'http://${dotenv.env['IP_REDE_LOCAL']}:${dotenv.env['PORTA_SERVIDOR']}';

Future<List<UsuarioApp>> consultaUsuariosApp() async {
  final url = Uri.parse('$serverUrl/usuarios');
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Decodifica a resposta JSON para uma lista
      final List<dynamic> usuariosJson = jsonDecode(response.body);
      
      // Mapeia cada item da lista JSON para uma instância de UsuarioApp
      final usuarios = usuariosJson.map((json) => UsuarioApp.fromJson(json)).toList();
      
      return usuarios;
    } else {
      print('Erro ao obter usuários: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Erro: $e');
    return [];
  }
}

Future<List<int>> consultaEmails(String email) async {
  final url = Uri.parse('$serverUrl/usuarios');  // Requisição sem filtros para o servidor

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> usuariosJson = jsonDecode(response.body);
      
      final idDoUsuario = usuariosJson
          .map((json) => UsuarioApp.fromJson(json))
          .where((usuario) => usuario.email == email)  // Filtragem 
          .map((usuario) => usuario.idUsuario)  // Extrai apenas o idUsuario
          .toList();
      
      return idDoUsuario;
    } else {
      print('Erro ao obter id: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Erro: $e');
    return [];
  }
}

Future<String> achaUserID(emailBusca) async {
  final url = Uri.parse('$serverUrl/usuarios');  // Requisição sem filtros para o servidor

  try {
    // Fazendo a requisição HTTP para buscar todos os usuários
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> usuariosJson = jsonDecode(response.body);
      
      // Filtra o usuário com o e-mail correspondente
      var user = usuariosJson.firstWhere((usuario) => usuario['email'] == emailBusca, orElse: () => null);

      if (user != null) {
        // Retorna o ID do usuário encontrado
        return user['id_usuario'].toString();
      } else {
        // Retorna uma mensagem de erro caso o usuário não seja encontrado
        return 'Usuário não encontrado';
      }
    } else {
      print('Erro ao obter usuário: ${response.statusCode}');
      return 'Erro ao obter dados dos usuário';
    }
  } catch (e) {
    print('Erro: $e');
    return 'Erro na requisição';
  }
}

// Função para inserir um novo usuário
Future<void> inserirUsuario(String nome, String email, String linkFoto, String telefone, String senha) async {
  final url = Uri.parse('$serverUrl/usuarios/novo'); // Rota para inserir um novo usuário

  // Cria o JSON com os dados do novo usuário
  final usuarioData = {
    'nome': nome,
    'email': email,
    'link_foto': linkFoto,
    'telefone': telefone,
    'senha': senha,
  };

  try {
    // Envia uma requisição POST com os dados do usuário
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioData),
    );

    // Verifica o status da resposta
    if (response.statusCode == 200) {
      print('Usuário inserido com sucesso!');
    } else {
      print('Erro ao inserir usuário: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');
    }
  } catch (e) {
    print('Erro ao inserir usuário: $e');
  }
}

// Função para atualizar dados do usuário
Future<void> editarUsuario(int idUsuario, String? novoNome, String? novoEmail, String? novalinkFoto, String? novoTelefone, String? novaSenha) async {
  final url = Uri.parse('$serverUrl/usuarios/$idUsuario'); // Endpoint de atualização

  // Cria o JSON com os dados atualizados
  final dadosAtualizados = {
    if (novoNome != null) 'nome': novoNome,
    if (novoEmail != null) 'email': novoEmail,
    if (novalinkFoto != null) 'link_foto': novalinkFoto,
    if (novoTelefone != null) 'telefone': novoTelefone,
    if (novaSenha != null) 'senha': novaSenha,
  };

  try {
    // Envia uma requisição PUT com os dados atualizados
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dadosAtualizados),
    );

    // Verifica o status da resposta
    if (response.statusCode == 200) {
      print('Usuário atualizado com sucesso!');
    } else {
      print('Erro ao atualizar usuário: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');
    }
  } catch (e) {
    print('Erro ao atualizar usuário: $e');
  }
}

Future<void> deletaUsuario(String idUsuario) async {
  final url = Uri.parse('$serverUrl/usuarios/delete');  // URL para deletar usuários

  // Cria o JSON com os dados do novo usuário
  final usuarioData = {
    'id_usuario': idUsuario,
  };

  try {
    // Envia uma requisição POST com os dados do usuário
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioData),
    );

    // Verifica o status da resposta
    if (response.statusCode == 200) {
      print('Usuário deletado com sucesso!');
    } else {
      print('Erro ao deleatr usuário: ${response.statusCode}');
      print('Resposta do servidor: ${response.body}');
    }
  } catch (e) {
    print('Erro ao deletar o usuário: $e');
  }
}

// Simula o processo de recuperação de senha
Future<String?> recuperaSenha(String email) async {
  await Future.delayed(const Duration(seconds: 2)); // Simula um atraso de 2 segundos
  String senha;
  // Simula a lógica de recuperação de senha
  List<UsuarioApp> usuarios = await consultaUsuariosApp();
  for (final usuario in usuarios) {
    if (usuario.email == email) {
      senha = usuario.senha;
      enviarEmailAutomatizado(email, 'Recuperar senha', senha);
      return null; // Retorna null se a recuperação de senha for bem sucedida
    }
  }
  return 'e-mail do usuário não encontrado'; // Retorna uma mensagem de erro
}


Future<void> enviarEmailAutomatizado( String destinatario, String assunto, String senha) async {
  // Configurações do servidor SMTP
  String username = '@gmail.com';
  String senha = 'suaSenhaDeApp'; // Atenção: use uma senha de app, se necessário

  final smtpServer = gmail(username, senha);

  // Cria o e-mail
  final email = Message()
    ..from = Address(username, 'Nome do Remetente')
    ..recipients.add(destinatario)
    ..subject = assunto
    ..text = "Olá, a sua senhade login no aplicativo de gerenciamento de projetos - BAP é:\nSenha: $senha";

  try {
    // Envia o e-mail
    final sendReport = await send(email, smtpServer);
    print('E-mail enviado: ${sendReport.toString()}');
  } on MailerException catch (e) {
    print('Erro ao enviar e-mail: $e');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}
