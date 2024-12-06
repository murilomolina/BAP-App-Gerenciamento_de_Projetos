import 'package:bap_gerenciamento_projetos/widgets/card_nav_list.dart';
import 'package:bap_gerenciamento_projetos/widgets/titulo_divider.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 0),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tituloDivider(context, 'Gerenciamento de Projetos'),
            cardNavList(),
            tituloDivider(context, 'Gerenciamento de Contatos'),
            cardNavListContato(),
          ],
        ),
      ),
    );
  }
}