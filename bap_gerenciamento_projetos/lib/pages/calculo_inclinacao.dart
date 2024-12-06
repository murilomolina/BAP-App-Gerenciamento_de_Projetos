import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';

class Calculoinclinacao extends StatefulWidget {
  const Calculoinclinacao({super.key});

  @override
  State<Calculoinclinacao> createState() => _CalculoinclinacaoState();
}

class _CalculoinclinacaoState extends State<Calculoinclinacao> {
  final TextEditingController _comprimentoController = TextEditingController();
  final TextEditingController _inclinacaoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  
  String _resultado = '';
  String _dadosComplementares = '';

  void calcular() {
    setState(() {
      double? comprimento = _comprimentoController.text.isNotEmpty
          ? double.tryParse(_comprimentoController.text.replaceAll(',', '.'))
          : null;
      double? inclinacao = _inclinacaoController.text.isNotEmpty
          ? double.tryParse(_inclinacaoController.text.replaceAll(',', '.'))
          : null;
      double? altura = _alturaController.text.isNotEmpty
          ? double.tryParse(_alturaController.text.replaceAll(',', '.'))
          : null;

      if (comprimento == null && inclinacao != null && altura != null) {
        comprimento = (altura * 100) / inclinacao;
        _resultado = 'Comprimento (c): ${comprimento.toStringAsFixed(6)} metros';
        _dadosComplementares = 'Altura (h): ${altura.toStringAsFixed(6)} metros\nInclinação (i): ${inclinacao.toStringAsFixed(6)} %';
      } else if (inclinacao == null && comprimento != null && altura != null) {
        inclinacao = (altura * 100) / comprimento;
        _resultado = 'Inclinação (i): ${inclinacao.toStringAsFixed(6)}%';
        _dadosComplementares = 'Altura (h): ${altura.toStringAsFixed(6)} metros\nComprimento (c): ${comprimento.toStringAsFixed(6)} metros';
      } else if (altura == null && comprimento != null && inclinacao != null) {
        altura = (inclinacao * comprimento) / 100;
        _resultado = 'Altura (h): ${altura.toStringAsFixed(6)} metros';
        _dadosComplementares = 'Inclinação (i): ${inclinacao.toStringAsFixed(6)} %\nComprimento (c): ${comprimento.toStringAsFixed(6)} metros';
      } else {
        _resultado = 'Erro: Forneça dois valores para calcular o terceiro.';
        _dadosComplementares = '';
      }
    });
  }

  void limparCampos() {
    _comprimentoController.clear();
    _inclinacaoController.clear();
    _alturaController.clear();
    setState(() {
      _resultado = '';
      _dadosComplementares = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calcule automaticamente os campos em branco.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _comprimentoController,
                decoration: const InputDecoration(
                  labelText: 'Insira o comprimento (c):',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _inclinacaoController,
                decoration: const InputDecoration(
                  labelText: 'Insira a inclinação (i):',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _alturaController,
                decoration: const InputDecoration(
                  labelText: 'Insira a altura (h):',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: calcular,
                    child: const Text('Calcular'),
                    
                  ),
                  ElevatedButton(
                    onPressed: limparCampos,
                    style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
                    child: const Text('Limpar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _resultado,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _dadosComplementares,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
