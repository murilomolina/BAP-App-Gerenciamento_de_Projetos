import 'package:bap_gerenciamento_projetos/blocs/bloc_contato.dart';
import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';

class CadastraContato extends StatelessWidget {
  const CadastraContato({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.ofCadastraContato(context);
    final blocLogin = Provider.ofLoginUsuario(context);
    bloc!.setPertenceUsuario(blocLogin!.idUsuario as int);

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Mais espaçamento geral
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título da página
              Text(
                'Adicionar Contato',
                style: TextStyle(
                  fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 20), // Espaçamento entre o título e os campos

              // Campos de entrada
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _nomeField(bloc),
                  _emailField(bloc),
                  _telefoneField(bloc),
                  _cpfField(bloc),
                  _rgField(bloc),
                  _chavePixField(bloc),
                  _enderecoRuaField(bloc),
                  _enderecoNumeroField(bloc),
                  _enderecoBairroField(bloc),
                  _enderecoCidadeField(bloc),
                  _enderecoCepField(bloc),
                  _enderecoObservacoesField(bloc),
                ],
              ),
              const SizedBox(height: 20),

              // Botões de ação
              _cadastraButton(bloc),
              const SizedBox(height: 10),
              _limpaCampos(bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nomeField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.nome,
      hint: 'Nome e Sobrenome',
      label: 'Insira o nome do contato',
      onChanged: (valor) => bloc.changeNome(valor),
    );
  }

  Widget _emailField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.email,
      hint: 'e-mail',
      label: 'contato@email.com',
      onChanged: (valor) => bloc.changeEmail(valor),
    );
  }

  Widget _telefoneField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.telefone,
      hint: 'telefone',
      label: 'Insira o telefone (11xxxxxxxx)',
      onChanged: (valor) => bloc.changeTelefone(valor),
    );
  }

  Widget _cpfField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.cpf,
      hint: 'CPF',
      label: 'Insira o CPF do contato',
      onChanged: (valor) => bloc.changeCpf(valor),
    );
  }

  Widget _rgField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.rg,
      hint: 'RG',
      label: 'Insira o RG',
      onChanged: (valor) => bloc.changeRg(valor),
    );
  }

  Widget _chavePixField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.chavePix,
      hint: 'Chave Pix',
      label: 'Insira a Chave Pix do contato',
      onChanged: (valor) => bloc.changeChavePix(valor),
    );
  }

  Widget _enderecoRuaField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoRua,
      hint: 'Rua',
      label: 'Insira a rua do contato',
      onChanged: (valor) => bloc.changeEnderecoRua(valor),
    );
  }

  Widget _enderecoNumeroField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoNumero,
      hint: 'Número',
      label: 'Insira o número do endereço',
      onChanged: (valor) => bloc.changeEnderecoNumero(valor),
    );
  }

  Widget _enderecoBairroField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoBairro,
      hint: 'Bairro',
      label: 'Insira o bairro do contato',
      onChanged: (valor) => bloc.changeEnderecoBairro(valor),
    );
  }

  Widget _enderecoCidadeField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoCidade,
      hint: 'Cidade',
      label: 'Insira a cidade do contato',
      onChanged: (valor) => bloc.changeEnderecoCidade(valor),
    );
  }

  Widget _enderecoCepField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoCEP,
      hint: 'CEP',
      label: 'Insira o CEP do contato',
      onChanged: (valor) => bloc.changeEnderecoCEP(valor),
    );
  }

  Widget _enderecoObservacoesField(CadastraContatoBloc bloc) {
    return _buildTextField(
      bloc: bloc,
      stream: bloc.enderecoObservacoes,
      hint: 'Observações do endereço',
      label: 'Insira observações do endereço',
      onChanged: (valor) => bloc.changeEnderecoObservacoes(valor),
    );
  }

  Widget _buildTextField({
    required CadastraContatoBloc bloc,
    required Stream<String> stream,
    required String hint,
    required String label,
    required Function(String) onChanged,
  }) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          child: TextField(
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              labelText: label,
              labelStyle: TextStyle(color: Colors.blueGrey[600]),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        );
      },
    );
  }

  Widget _cadastraButton(CadastraContatoBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.camposCadastroAreOk,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => bloc.cadastraContato() : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Cadastrar'),
        );
      },
    );
  }

  Widget _limpaCampos(CadastraContatoBloc bloc) {
    return StreamBuilder<bool>(
      stream: bloc.camposCadastroAreOk,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData ? () => bloc.limpaCampos() : null,
          style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
          child: const Text('Limpar Campos', style: TextStyle(color: Colors.white),),
        );
      },
    );
  }
}
