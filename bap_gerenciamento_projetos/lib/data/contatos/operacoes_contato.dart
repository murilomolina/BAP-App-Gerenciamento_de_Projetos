import 'dart:convert';
import 'package:bap_gerenciamento_projetos/data/endereco.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Contato {
  int idContato;
  int pertenceUsuario; // aqui vem o id do usuario que cadastrou esse contato.
  String nome;
  String? email;
  String telefone;
  String? cpf;
  String? rg;
  String? chavePix;
  Endereco? endereco;

  // Construtor
  Contato({
    required this.idContato,
    required this.pertenceUsuario,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.rg,
    required this.chavePix,
    required this.endereco
  });
  
  // Método para criar uma instância de Contato a partir de um Map (JSON)
  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      idContato: json['id_contato'],
      pertenceUsuario: json['pertence_usuario'],
      nome: json['nome'],
      email: json['email'] ?? 'null',
      telefone: json['telefone'],
      cpf: json['cpf'] ?? 'null',
      rg: json['rg'] ?? 'null',
      chavePix: json['chave_pix'] ?? 'null',
       endereco: Endereco.fromJson(json['endereco']),
    );
  }
}

// URL do servidor (substitua pelo IP e porta configurados)
var serverUrl = 'http://${dotenv.env['IP_REDE_LOCAL']}:${dotenv.env['PORTA_SERVIDOR']}';

Future<List<Contato>> getTodosContatos() async {
  final url = Uri.parse('$serverUrl/contatos');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON para uma lista dinâmica
      final decodedResponse = jsonDecode(response.body);

      if (decodedResponse is List) {
        // Mapeia cada item da lista JSON para uma instância de Contato
        return decodedResponse
            .map<Contato>((json) => Contato.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('Erro: A resposta do servidor não está no formato esperado (não é uma lista).');
        return [];
      }
    } else {
      print('Erro ao obter contatos: Código HTTP ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Erro ao consultar contatos: $e');
    return [];
  }
}

Future<bool> cadastrarContato(int pertenceUsuario, String nome, String? email, String telefone, String? cpf, String? rg, String? chavePix, String? rua, String? numero, String? bairro, String? cidade, String? cep, String? observacoes)async {
  final url = Uri.parse('$serverUrl/contatos/novo'); // URL para o endpoint de cadastro de contatos

  try {
    // Cria um Map com os dados do contato para enviar no corpo da requisição
    final Map<String, dynamic> contatoJson = {
      'pertence_usuario': pertenceUsuario,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'rg': rg,
      'chave_pix': chavePix,
      'endereco': {
        'rua': rua,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'cep': cep,
        'observacoes': observacoes,
      },
    };

    // Envia a requisição POST com o JSON no corpo
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contatoJson),
    );

    if (response.statusCode == 201) {
      // Sucesso! O contato foi criado
      print('Contato cadastrado com sucesso.');
      return true;
    } else {
      // Caso não tenha sido bem-sucedido, mostra o erro
      print('Erro ao cadastrar contato: Código HTTP ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Se ocorrer algum erro durante a requisição, mostra o erro
    print('Erro ao cadastrar contato: $e');
    return false;
  }
}

Future<bool> excluirContato(int idContato) async {
  final url = Uri.parse('$serverUrl/contatos/$idContato'); // URL para o contato específico

  try {
    // Envia a requisição DELETE para excluir o contato
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Sucesso! O contato foi excluído
      print('Contato excluído com sucesso.');
      return true;
    } else {
      // Caso não tenha sido bem-sucedido, mostra o erro
      print('Erro ao excluir contato: Código HTTP ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Se ocorrer algum erro durante a requisição, mostra o erro
    print('Erro ao excluir contato: $e');
    return false;
  }
}
