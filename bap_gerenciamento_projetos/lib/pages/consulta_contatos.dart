import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';

class ConsultaContatos extends StatelessWidget {
  const ConsultaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> searchQuery = ValueNotifier('');
    final ValueNotifier<List<Map<String, dynamic>>> contatosNotifier = ValueNotifier([]);

    // Carregar os contatos inicialmente
    _carregarContatos(contatosNotifier);


    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: Column(
        children: [
          _barraDeBusca(searchQuery),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: contatosNotifier,
              builder: (context, contatos, child) {
                if (contatos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ValueListenableBuilder<String>(
                  valueListenable: searchQuery,
                  builder: (context, query, child) {
                    // Filtrando os contatos com base na query
                    final filteredContatos = contatos.where((contato) {
                      return contato['nome_contato'].toLowerCase().contains(query.toLowerCase());
                    }).toList();

                    if (filteredContatos.isEmpty) {
                      return const Center(child: Text('Nenhum contato encontrado.'));
                    }

                    return ListView.builder(
                      itemCount: filteredContatos.length,
                      itemBuilder: (context, index) {
                        final contato = filteredContatos[index];
                        return _itemContato(contato, context);
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

  Future<void> _carregarContatos(ValueNotifier<List<Map<String, dynamic>>> contatosNotifier) async {
    // final contatos = await getAllContatos();
    // contatosNotifier.value = contatos;
  }

  Widget _itemContato(Map<String, dynamic> contato, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 10,
      color: Theme.of(context).primaryColor,
      child: ListTile(
        title: Text(
          contato['nome_contato'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          contato['telefone_contato'],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () {
          _maisInfoContato(contato, context);
        },
      ),
    );
  }

  void _maisInfoContato(Map<String, dynamic> contato, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                  const Text(' Informações'),
                ],
              ),
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 153, 153, 153),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o pop-up
                },
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contato['nome_contato'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(thickness: 2),
                  const SizedBox(height: 8),
                  _buildInfoRow('Telefone', contato['telefone_contato']),
                  _buildInfoRow('E-mail', contato['email_contato']),
                  
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navegar para a página de links no futuro.
                  },
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Linkar contato a um serviço'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  // Função auxiliar para criar uma linha de informações estilizadas
  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinhar texto à esquerda
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4), // Espaço entre o label e o valor
          Text(
            value,
            softWrap: true,
            overflow: TextOverflow.visible, // Faz o texto quebrar a linha automaticamente
          ),
        ],
      ),
    );
  }

  Widget _barraDeBusca(ValueNotifier<String> searchQuery) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar contatos (pelo nome do contato)',
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
}
