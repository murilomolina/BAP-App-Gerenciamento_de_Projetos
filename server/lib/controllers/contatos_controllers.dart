import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ContatosController {
  final Db db;
  late final DbCollection contatosCollection;

  ContatosController(this.db){
    contatosCollection = db.collection('contatos');
  }

  // Método GET: Lista todos os Contatos
  Future<Response> listarContatos(Request request) async {
    final contatos = await contatosCollection.find().toList();

    if (contatos.isNotEmpty) {
      return Response.ok(jsonEncode(contatos), headers: {'Content-Type': 'application/json'});
    } else {
      return Response.ok('[]', headers: {'Content-Type': 'application/json'});
    }
  }

  // Método POST: Cria um novo usuário
  Future<Response> cadastrarContato(Request request) async {
    try {
      final data = await request.readAsString();
      final contatoMap = jsonDecode(data);

      // Obtém o maior ID de usuário e incrementa
      final maiorId = await achaMaiorIdContato() ?? 0;
      final novoIdContato = maiorId + 1;

      // Cria o objeto Contato
      final result = await contatosCollection.insertOne({
      'id_contato': novoIdContato,
      'pertence_usuario': contatoMap['pertence_usuario'],
      'nome': contatoMap['nome'],
      'email': contatoMap['email'],
      'telefone': contatoMap['telefone'],
      'cpf': contatoMap['cpf'],
      'rg': contatoMap['rg'],
      'chave_pix': contatoMap['chave_pix'],
      'endereco': {
        'rua': contatoMap['endereco']['rua'],
        'numero': contatoMap['endereco']['numero'],
        'bairro': contatoMap['endereco']['bairro'],
        'cidade': contatoMap['endereco']['cidade'],
        'cep': contatoMap['endereco']['cep'],
        'observacoes': contatoMap['endereco']['observacoes'],
      }});
      
      if(result.isSuccess){
        return Response.ok('Usuário criado com sucesso');
      }else{
        return Response.internalServerError(body: 'Erro ao inserir usuário'); 
      }
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao criar usuário: $e');
    }
  }


  // Função para encontrar o maior ID de Contato
  Future<int?> achaMaiorIdContato() async {
    try {
      final maiorContato = await contatosCollection
          .find(where.sortBy('id_contato', descending: true).limit(1))
          .toList();

      if (maiorContato.isNotEmpty) {
        return maiorContato.first['id_contato'] as int?;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar maior ID de Contato: $e');
      return null;
    }
  }
}