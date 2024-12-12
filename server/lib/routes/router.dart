import 'package:server/controllers/contatos_controllers.dart';
import 'package:server/controllers/usuarios_controllers.dart';
import 'package:server/routes/contatos_routes.dart';
import 'package:server/routes/usuarios_app_routes.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

Router criarRouter(
  UsuariosController usuariosController,
  // ProjetosController projetosController,
  ContatosController contatosController,
  // ProcuracaoController procuracaoController,
) {
  final router = Router();

  // Rotas de usuários
  router.mount('/usuarios', usuariosRoutes(usuariosController));

  // // Rotas de projetos
  // router.mount('/projetos', projetosRoutes(projetosController));

  // Rotas de contatos
  router.mount('/contatos', contatosRoutes(contatosController));

  // // Rotas de procuração
  // router.mount('/procuracao', procuracaoRoutes(procuracaoController));

  // Rota padrão para 404
  router.all('/<ignored|.*>', (request) {
    return Response.notFound('Rota não encontrada');
  });

  return router;
}
