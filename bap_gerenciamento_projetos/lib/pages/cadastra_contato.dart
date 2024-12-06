import 'package:bap_gerenciamento_projetos/classes/custom_appbar.dart';
import 'package:bap_gerenciamento_projetos/classes/custom_drawer.dart';
import 'package:flutter/material.dart';

class CadastraContato extends StatelessWidget {
  const CadastraContato({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(pagType: 1),
      body: Center(child: ElevatedButton(onPressed:() async {
        
      }, child: const Text("cadastra")
      )
      )
    );
  }
}