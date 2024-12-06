import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
// import 'package:bap_gerenciamento_projetos/data/projetos/projetos_data.dart';
import 'package:flutter/material.dart';

class PaginaProjetos extends StatelessWidget {
  const PaginaProjetos({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> searchQuery = ValueNotifier('');
    final ValueNotifier<List<Map<String, dynamic>>> projetosNotifier = ValueNotifier([]);

    // Carregar os projetos inicialmente
    _carregarProjetos(projetosNotifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: _botaoAdd(context, projetosNotifier),
      drawer: const CustomDrawer(pagType: 1),
      body: Column(
        children: [
          _barraDeBusca(searchQuery),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: projetosNotifier,
              builder: (context, projetos, child) {
                if (projetos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ValueListenableBuilder<String>(
                  valueListenable: searchQuery,
                  builder: (context, query, child) {
                    // Filtrando os projetos com base na query
                    final filteredProjects = projetos.where((projeto) {
                      return projeto['nome_projeto'].toLowerCase().contains(query.toLowerCase());
                    }).toList();

                    if (filteredProjects.isEmpty) {
                      return const Center(child: Text('Nenhum projeto encontrado.'));
                    }

                    return ListView.builder(
                      itemCount: filteredProjects.length,
                      itemBuilder: (context, index) {
                        final projeto = filteredProjects[index];
                        return _itemProjeto(projeto, context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _carregarProjetos(ValueNotifier<List<Map<String, dynamic>>> projetosNotifier) async {
    // final projetos = await getTodosProjetos();
    // projetosNotifier.value = projetos;
  }

  Widget _barraDeBusca(ValueNotifier<String> searchQuery) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar projetos (pelo nome do projeto)',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          // Atualizando a query de busca
          searchQuery.value = value;
        },
      ),
    );
  }

  Widget _itemProjeto(Map<String, dynamic> projeto, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 10,
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(
          projeto['nome_projeto'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          projeto['tipo_projeto'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          // pop-up
        },
      ),
    );
  }

  Widget _botaoAdd(BuildContext context, ValueNotifier<List<Map<String, dynamic>>> projetosNotifier) {
    return ElevatedButton(
      onPressed: () {
        _showAddProjetoDialog(context, projetosNotifier);
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Theme.of(context).primaryColor,
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 10,
      ),
      child: const Icon(
        Icons.add,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Future<void> _showAddProjetoDialog(BuildContext context, ValueNotifier<List<Map<String, dynamic>>> projetosNotifier) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController tipoController = TextEditingController();
    final TextEditingController enderecoController = TextEditingController();
    final TextEditingController dataInicioController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Novo Projeto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do Projeto'),
                ),
                TextField(
                  controller: tipoController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
                TextField(
                  controller: enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),
                TextField(
                  controller: dataInicioController,
                  decoration: const InputDecoration(labelText: 'Data de Início'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                // Adiciona o projeto ao banco e atualiza a lista
                // await addProjetoBanco(
                //   nomeController.text,
                //   tipoController.text,
                //   enderecoController.text,
                //   dataInicioController.text,
                // );

                // Recarregar os projetos
                await _carregarProjetos(projetosNotifier);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
