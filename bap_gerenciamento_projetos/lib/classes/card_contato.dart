import 'package:bap_gerenciamento_projetos/data/contatos/operacoes_contato.dart';
import 'package:bap_gerenciamento_projetos/data/usuarioAPP/operacoes_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CardContato extends StatelessWidget {
  final Contato contato;

  const CardContato(this.contato, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      child: ListTile(
        title: _buildTitle(context),
        subtitle: Text(contato.telefone),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _mostrarDetalhesContato(context),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      contato.nome,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  void _mostrarDetalhesContato(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: _buildTituloPopUp(context),
        content: _buildConteudoPopUp(context),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBotaoAcao(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTituloPopUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTituloIcone(context),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }

  Widget _buildTituloIcone(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        const Text('Informações'),
      ],
    );
  }

  Widget _buildConteudoPopUp(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPertenceUsuario('Cadastrado por', contato.pertenceUsuario),          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInformacaoContato('Nome', contato.nome),
              const Divider(thickness: 1.5),
              _buildInformacaoContato('E-mail', contato.email ?? 'null'),
              _buildInformacaoContato('Telefone', contato.telefone),
              _buildInformacaoContato('CPF', contato.cpf ?? 'null'),
              _buildInformacaoContato('RG', contato.rg ?? 'null'),
              _buildInformacaoContato('Chave pix', contato.chavePix ?? 'null'),
              _buildEnderecoContato(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPertenceUsuario(String titulo, int valor) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$titulo:',
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[700]),
        ),
        const SizedBox(height: 4),
        FutureBuilder<String>(
          future: achaUserNome(valor),  // Chama a função diretamente no FutureBuilder
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Carregando...', style: TextStyle(fontSize: 14));
            }
            if (snapshot.hasError) {
              return const Text('Erro ao carregar nome', style: TextStyle(fontSize: 14));
            }
            return Text(snapshot.data ?? 'Usuário não encontrado', style: TextStyle(fontSize: 14, color: Colors.grey[700]));
          },
        ),
      ],
    ),
  );
}


  Widget _buildInformacaoContato(String titulo, String valor) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$titulo:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        // const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                valor,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis, // Impede o texto de ultrapassar
                maxLines: 1, // Limita a quantidade de linhas
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: valor));
                // Exibir um feedback visual, como um Snackbar
                Fluttertoast.showToast(msg: 'Texto copiado para a área de transferencia.');
              },
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildEnderecoContato(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnderecoTitulo(context),
          _buildInformacaoContato('Rua', contato.endereco?.rua ?? 'null'),
          _buildInformacaoContato('Número', contato.endereco?.numero ?? 'null'),
          _buildInformacaoContato('Bairro', contato.endereco?.bairro ?? 'null'),
          _buildInformacaoContato('Cidade', contato.endereco?.cidade ?? 'null'),
          _buildInformacaoContato('CEP', contato.endereco?.cep ?? 'null'),
          _buildInformacaoContato('Observações', contato.endereco?.observacoes ?? 'null'),
        ],
      ),
    );
  }

  Widget _buildEnderecoTitulo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(Icons.home, color: Theme.of(context).primaryColor),
          const Text(
            'Endereço',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoAcao(BuildContext context) {
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
