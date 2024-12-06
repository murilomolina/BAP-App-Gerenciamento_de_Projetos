import 'package:bap_gerenciamento_projetos/pages/cadastra_contato.dart';
import 'package:bap_gerenciamento_projetos/pages/consulta_contatos.dart';
import 'package:bap_gerenciamento_projetos/pages/fazer_procuracao.dart';
import 'package:bap_gerenciamento_projetos/pages/home_page.dart';
import 'package:bap_gerenciamento_projetos/classes/card_navegacao.dart';
import 'package:bap_gerenciamento_projetos/pages/pagina_projetos.dart';
import 'package:flutter/material.dart';


Widget cardNavList(){
  return const Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Wrap(
          spacing: 40.0,
          runSpacing: 40.0,
          children: [
            CardNavegacao(
              titulo: 'Projetos',
              paginaDestino: PaginaProjetos(),
              cardType: 'projetos',
            ),
            CardNavegacao(
              titulo: 'Inspeções',
              paginaDestino: HomePage(),
              cardType: 'projetos',
            ),
            CardNavegacao(
              titulo: 'Vistorias',
              paginaDestino: HomePage(),
              cardType: 'projetos',
            ),
            CardNavegacao(
              titulo: 'Laudos',
              paginaDestino: HomePage(),
              cardType: 'projetos',
            ),
            CardNavegacao(
              titulo: 'Fazer Procuração',
              paginaDestino: FazerProcuracao(),
              cardType: 'projetos',
            )
          ],
        ),
      )
    ],
  );
}
Widget cardNavListContato(){
  return const Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Wrap(
          spacing: 40.0,
          runSpacing: 40.0,
          children: [
            CardNavegacao(
              titulo: 'Cadastra Contato',
              paginaDestino: CadastraContato(),
              cardType: 'contatos',
            ),
            CardNavegacao(
              titulo: 'Constulta Contatos',
              paginaDestino: ConsultaContatos(),
              cardType: 'contatos',
            ),
          ],
        ),
      )
    ],
  );
}
