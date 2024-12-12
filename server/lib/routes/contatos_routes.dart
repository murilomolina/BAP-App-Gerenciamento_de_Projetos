import 'package:server/controllers/contatos_controllers.dart';
import 'package:shelf_router/shelf_router.dart';

Router contatosRoutes(ContatosController controller) {
  final router = Router();

  router.get('/', controller.listarContatos); // Listar todos os contatos (geral)

  return router;
}