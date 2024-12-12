import 'package:mongo_dart/mongo_dart.dart';
import 'package:server/controllers/contatos_controllers.dart';
import 'package:server/controllers/usuarios_controllers.dart';
import 'package:server/database.dart';
import 'package:server/routes/router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:dotenv/dotenv.dart';

// CONFIGURAÇÕES
const port = 8081;

void start() async {
  // Carrega as variáveis de ambiente
  var env = DotEnv(includePlatformEnvironment: true)..load();

  Db db = await conectarAoBanco();
  
  // Controladores
  final usuariosController = UsuariosController(db);
  final contatosController = ContatosController(db);
  // final projetosController = ProjetosController(db);
  // final procuracaoController = ProcuracaoController(db);

  // Rotas
  final router = criarRouter(
    usuariosController,
    contatosController,
    // projetosController,
    // procuracaoController,
  );

  // Cria o handler para o servidor com middlewares
  final handler = const Pipeline()
      .addMiddleware(logRequests()) // Middleware para log de requisições
      .addMiddleware(corsHeaders()) // Middleware CORS
      .addHandler(router);

  // Inicia o servidor na rede local configurada
  final server = await shelf_io.serve(handler, env['IP_REDE_LOCAL'].toString(), port);
  print('Servidor rodando em http://${env['IP_REDE_LOCAL']}:${server.port}');
}
