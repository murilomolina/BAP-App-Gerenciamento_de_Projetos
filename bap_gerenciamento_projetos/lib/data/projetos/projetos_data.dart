// import 'package:bap_gerenciamento_projetos/data/data_helper.dart';
// import 'package:sqflite/sqflite.dart';

// Future<void> addProjetoBanco(String nome, String tipo, String endereco, String dataInicio) async {
//   final Database db = await DatabaseHelper().database; // Inicializa o banco de dados
//     await db.insert('projetos', {
//       'nome_projeto': nome,
//       'tipo_projeto': tipo,
//       'endereco_projeto': endereco,
//       'data_inicio_projeto': dataInicio,
//     });
//   }

// Future<void> deletaProjeto(String nome) async {
//   final Database db = await DatabaseHelper().database; // Inicializa o banco de dados
//   await db.delete(
//     'projetos',
//     where: 'nome_projeto = ?', // '?' prevenção de injeção de SQL
//     whereArgs: [nome],  // Passa o nome como argumento
//   );
// }

// Future<void> editaProjeto(String nomeOriginal, Map<String, dynamic> novosDados) async {
//   final Database db = await DatabaseHelper().database;
//   await db.update(
//     'projetos',
//     novosDados,
//     where: 'nome_projeto = ?',
//     whereArgs: [nomeOriginal],
//   );
// }

// Future<List<Map<String, dynamic>>> getTodosProjetos() async {
//   final Database db = await DatabaseHelper().database; // Inicializa o banco de dados
  
//   // Realiza a consulta para buscar todos os projetos
//   final List<Map<String, dynamic>> todosProjetos = await db.query('projetos');
  
//   return todosProjetos; // Retorna todos os projetos como uma lista de Map
// }