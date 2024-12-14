import 'package:bap_gerenciamento_projetos/classes/card_contato.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:bap_gerenciamento_projetos/data/contatos/operacoes_contato.dart';
import 'package:flutter/material.dart';

class ConsultaContatos extends StatelessWidget {
  const ConsultaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    final searchQuery = ValueNotifier<String>('');
    final contatosNotifier = ValueNotifier<List<Contato>>([]); // Alterado para List<Contato>

    _carregarContatos(contatosNotifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: Column(
        children: [
          _barraDeBusca(searchQuery, context),
          Expanded(
            child: ValueListenableBuilder<List<Contato>>( // Alterado para List<Contato>
              valueListenable: contatosNotifier,
              builder: (context, contatos, _) {
                if (contatos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ValueListenableBuilder<String>(
                  valueListenable: searchQuery,
                  builder: (context, query, _) {
                    final filteredContatos = _filtrarContatos(contatos, query);

                    if (filteredContatos.isEmpty) {
                      return const Center(child: Text('Nenhum contato encontrado.'));
                    }

                    return ListView.builder(
                      itemCount: filteredContatos.length,
                      itemBuilder: (context, index) {
                        return CardContato(filteredContatos[index]);
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

  Future<void> _carregarContatos(ValueNotifier<List<Contato>> contatosNotifier) async { // Alterado para List<Contato>
    try {
      final contatos = await getTodosContatos(); // Obtém a lista de Contatos
      contatosNotifier.value = contatos; // Atualiza o ValueNotifier com a lista de Contatos
    } catch (e) {
      print('Erro ao carregar contatos: $e');
    }
  }

  Widget _barraDeBusca(ValueNotifier<String> searchQuery, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        elevation: 4, // Sombra para destaque
        borderRadius: BorderRadius.circular(15),
        child: TextField(
          decoration: InputDecoration(
            // labelText: 'Buscar contatos',
            hintText: 'Nome ou telefone do contato...',
            hintStyle: TextStyle(
              color: Colors.grey[700], 
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon:  Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none, // Remove a borda padrão
            ),
            filled: true,
            fillColor: Colors.grey[100], // Fundo sutil
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          style: const TextStyle(fontSize: 16.0),
          cursorColor: Colors.blueAccent, // Cor do cursor
          onChanged: (value) => searchQuery.value = value,
        ),
      ),
    );
  }

  List<Contato> _filtrarContatos(List<Contato> contatos, String query) { // Alterado para List<Contato>
    return contatos
        .where((contato) => (contato.nome.toLowerCase().contains(query.toLowerCase()) || contato.telefone.contains(query.toLowerCase())))
        .toList();
  }
}
