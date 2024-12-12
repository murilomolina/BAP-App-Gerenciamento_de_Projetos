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

}