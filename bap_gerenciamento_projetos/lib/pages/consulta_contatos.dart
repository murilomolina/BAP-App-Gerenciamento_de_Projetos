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
          _barraDeBusca(searchQuery),
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
                        return _itemContato(filteredContatos[index], context);
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

  Widget _barraDeBusca(ValueNotifier<String> searchQuery) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar contatos (pelo nome do contato)',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) => searchQuery.value = value,
      ),
    );
  }

  List<Contato> _filtrarContatos(List<Contato> contatos, String query) { // Alterado para List<Contato>
    return contatos
        .where((contato) => contato.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _itemContato(Contato contato, BuildContext context) { // Alterado para Contato
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      child: ListTile(
        title: Text(
          contato.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: Text(contato.telefone),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _mostrarDetalhesContato(contato, context),
      ),
    );
  }

  void _mostrarDetalhesContato(Contato contato, BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: _tituloPopUp(context),
        content: _conteudoPopUp(contato, context),
        actions: [Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _botaoAcao(context),
          ],
        )],
      ),
    );
  }

  Widget _tituloPopUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Informações'),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }

  Widget _conteudoPopUp(Contato contato, context) { // Alterado para Contato
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _informacaoContato('Nome', contato.nome),
          const Divider(thickness: 1.5),
          _informacaoContato('E-mail', contato.email),
          _informacaoContato('Telefone', contato.telefone),
          _informacaoContato('CPF', contato.cpf),
          _informacaoContato('RG', contato.rg),
          _informacaoContato('Chave pix', contato.chavePix),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.home, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 4),
                    const Text('Endereço', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ],
                ),
              ],
            ),
          ),
          _informacaoContato('Rua', contato.endereco.rua),
          _informacaoContato('Número', contato.endereco.numero),
          _informacaoContato('Bairro', contato.endereco.bairro),  
          _informacaoContato('Cidade', contato.endereco.cidade),
          _informacaoContato('CEP', contato.endereco.cep),
          _informacaoContato('Observações', contato.endereco.observacoes),        
        ],
      ),
    );
  }

  Widget _informacaoContato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _botaoAcao(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.work, size: 18),
      label: const Text('Serviços'),
    );
  }
}
