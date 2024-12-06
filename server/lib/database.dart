import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

// Função que cria a conexão com o banco de dados
Future<Db> conectarAoBanco() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  final db = await Db.create(
    'mongodb+srv://${env['USUARIO_MONGO_ATLAS']}:${env['SENHA_USUARIO_MONGO_ATLAS']}@${env['MONGO_CLUSTER_URL']}/gerenciamentoProjetos?retryWrites=true&w=majority&appName=ClusterBAP',
  );
  await db.open();
  print('db open');
  return db;
}
