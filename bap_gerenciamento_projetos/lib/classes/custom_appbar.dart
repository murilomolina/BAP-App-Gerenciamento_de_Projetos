import 'package:bap_gerenciamento_projetos/pages/home_page.dart';
import 'package:bap_gerenciamento_projetos/pages/perfil_logado.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          // Redirecionar para a página principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: Image.asset(
          'assets/logo/bap_logo.png',
          height: 50,
        ),
      ),
      actions: [
        IconButton(
          icon:  const Icon(Icons.person),
          tooltip: 'Meu Perfil',
            onPressed: () {
              Navigator.pop(context);
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilLogado()), 
              );
            },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
