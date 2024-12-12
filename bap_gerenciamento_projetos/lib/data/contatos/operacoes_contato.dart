import 'dart:convert';
import 'package:bap_gerenciamento_projetos/data/endereco.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Contato {
  int idContato;
  int pertenceUsuario; // aqui vem o id do usuario que cadastrou esse contato.
  String nome;
  String email;
  String telefone;
  String cpf;
  String rg;
  String chavePix;
  Endereco endereco;

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
