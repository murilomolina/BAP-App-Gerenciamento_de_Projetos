import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:bap_gerenciamento_projetos/widgets/titulo_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FazerProcuracao extends StatefulWidget {
  const FazerProcuracao({super.key});

  @override
  State<FazerProcuracao> createState() => _FazerProcuracaoState();
}

class _FazerProcuracaoState extends State<FazerProcuracao> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _contatos = []; // Lista completa dos contatos com detalhes
  List<String> _contatosFiltrados = []; // Lista dos nomes dos contatos após o filtro de busca
  final List<Map<String, dynamic>> _contatosSelecionados = []; // Lista dos contatos escolhidos

  final TextEditingController _buscaController = TextEditingController();
  final TextEditingController numeroPessoasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarContatos();
    _buscaController.addListener(_filtrarContatos);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    numeroPessoasController.dispose();
    super.dispose();
  }

  Future<void> _carregarContatos() async {
    // // Carrega os contatos com detalhes
    // final List<Map<String, dynamic>> contatosData = await getAllContatos();
    // setState(() {
    //   _contatos = contatosData; // Armazena todos os contatos
    //   _contatosFiltrados = contatosData.map((e) => e['nome_contato'].toString()).toList();
    // });
  }

  void _filtrarContatos() {
    final busca = _buscaController.text.toLowerCase();
    setState(() {
      _contatosFiltrados = _contatos
          .where((contato) => contato['nome_contato'].toString().toLowerCase().contains(busca))
          .map((contato) => contato['nome_contato'].toString())
          .toList();
    });
  }

  void _selecionarContato(String contatoNome) {
    // Encontra o contato pelo nome na lista completa
    final contato = _contatos.firstWhere((c) => c['nome_contato'] == contatoNome);

    // Adiciona à lista de selecionados se a quantidade não ultrapassar o valor de numeroPessoasController
    final int maxContatos = int.tryParse(numeroPessoasController.text) ?? 0;
    if (_contatosSelecionados.length < maxContatos) {
      setState(() {
        _contatosSelecionados.add(contato);
        _buscaController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite de contatos alcançado.')),
      );
    }
  }

  Widget buildEscolheContato() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _buscaController,
          decoration: const InputDecoration(
            labelText: 'Buscar Contato',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 10),
        if (_contatosFiltrados.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _contatosFiltrados.length,
              itemBuilder: (context, index) {
                final contatoNome = _contatosFiltrados[index];
                return ListTile(
                  title: Text(contatoNome),
                  onTap: () => _selecionarContato(contatoNome),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        // Exibe os contatos selecionados
        Wrap(
          children: _contatosSelecionados.map((contato) {
            return Chip(
              label: Text(contato['nome_contato']),
              deleteIcon: const Icon(Icons.close),
              onDeleted: () {
                setState(() {
                  _contatosSelecionados.remove(contato);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIntFormField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          int? intValue = int.tryParse(value);
          if (intValue == null || intValue < 1 || intValue > 5) {
            return 'Insira um número entre 1 e 5';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                tituloDivider(context, "Faça e encaminhe uma procuração"),
                _buildIntFormField(
                    numeroPessoasController,
                    'Número de pessoas na procuração incluindo você'),
                buildEscolheContato(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
