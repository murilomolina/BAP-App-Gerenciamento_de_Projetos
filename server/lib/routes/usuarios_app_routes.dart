import 'package:server/controllers/usuarios_controllers.dart';
import 'package:shelf_router/shelf_router.dart';

Router usuariosRoutes(UsuariosController controller) {
  final router = Router();

  router.get('/', controller.listarUsuarios); // Listar usuários
  router.get('/nomes', controller.listarNomesUsuarios); // listar apenas os nomes dos usuarios
  router.post('/novo', controller.criarUsuario); // Criar usuário
  router.put('/<id_usuario>', controller.atualizarUsuario); // Atualizar usuário
  router.delete('/delete', controller.deletarUsuario); // Deletar usuário

  return router;
}