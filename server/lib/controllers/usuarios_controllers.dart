import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UsuariosController {
  final Db db;
  late final DbCollection usuariosCollection;

  UsuariosController(this.db) {
    usuariosCollection = db.collection('usuarios');
  }

  // Método GET: Lista todos os usuários
  Future<Response> listarUsuarios(Request request) async {
    final usuarios = await usuariosCollection.find().toList();

    if (usuarios.isNotEmpty) {
      return Response.ok(jsonEncode(usuarios), headers: {'Content-Type': 'application/json'});
    } else {
      return Response.ok('[]', headers: {'Content-Type': 'application/json'});
    }
  }

  // Método POST: Cria um novo usuário
  Future<Response> criarUsuario(Request request) async {
    try {
      final data = await request.readAsString();
      final usuarioMap = jsonDecode(data);

      // Obtém o maior ID de usuário e incrementa
      final maiorId = await achaMaiorIdUsuario() ?? 0;
      final novoIdUsuario = maiorId + 1;

      // Cria o objeto Usuario
      final result = await usuariosCollection.insertOne({
        'id_usuario': novoIdUsuario,
        'nome': usuarioMap['nome'],
        'email': usuarioMap['email'],
        'link_foto': usuarioMap['link_foto'],
        'telefone': usuarioMap['telefone'],
        'senha': usuarioMap['senha'],
      });
      
      if(result.isSuccess){
        return Response.ok('Usuário criado com sucesso');
      }else{
        return Response.internalServerError(body: 'Erro ao inserir usuário'); 
      }
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao criar usuário: $e');
    }
  }

  // Método PUT: Atualiza um usuário
  Future<Response> atualizarUsuario(Request request, int idUsuario) async {
    try {
      final data = await request.readAsString();
      final usuarioMap = jsonDecode(data);

      final updateResult = await usuariosCollection.updateOne(
        where.eq('id_usuario', idUsuario),
        modify.set('nome', usuarioMap['nome'])
              .set('email', usuarioMap['email'])
              .set('link_foto', usuarioMap['link_foto'])
              .set('telefone', usuarioMap['telefone'])
              .set('senha', usuarioMap['senha']),
      );

      if (updateResult.isSuccess) {
        return Response.ok('Usuário atualizado com sucesso');
      } else {
        return Response.notFound('Usuário não encontrado');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao atualizar usuário: $e');
    }
  }

  // Método DELETE: Deleta um usuário
  Future<Response> deletarUsuario(Request request, int idUsuario) async {
    try {
      final deleteResult = await usuariosCollection.deleteOne({'id_usuario': idUsuario});
      if (deleteResult.isSuccess) {
        return Response.ok('Usuário deletado com sucesso');
      } else {
        return Response.notFound('Usuário não encontrado');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Erro ao deletar usuário: $e');
    }
  }

  // Função para encontrar o maior ID de usuário
  Future<int?> achaMaiorIdUsuario() async {
    try {
      final maiorUsuario = await usuariosCollection
          .find(where.sortBy('id_usuario', descending: true).limit(1))
          .toList();

      if (maiorUsuario.isNotEmpty) {
        return maiorUsuario.first['id_usuario'] as int?;
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar maior ID de usuário: $e');
      return null;
    }
  }

}
