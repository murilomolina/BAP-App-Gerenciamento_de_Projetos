import 'package:bap_gerenciamento_projetos/blocs/provider.dart';
import 'package:bap_gerenciamento_projetos/pages/calculo_inclinacao.dart';
import 'package:bap_gerenciamento_projetos/pages/home_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final int pagType;

  const CustomDrawer({super.key, required this.pagType});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.ofLoginUsuario(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: pagType == 0 ? <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Cor de fundo do cabeçalho
            ),
            child: Align(
              alignment: Alignment.topCenter, 
              child: Image.asset(
                'assets/logo/bap_logo.png',
                height: 75,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculos'),
            onTap: () {
              Navigator.pop(context);
              _showCalculationOptions(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              // Navegar para a página de configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              bloc!.logout(context);
            },
          )
        ]:
        <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor, // Cor de fundo do cabeçalho
            ),
            child: Align(
              alignment: Alignment.topLeft, 
              child: Image.asset(
                'assets/logo/bap_logo.png',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Página Inicial'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()), 
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calculos'),
            onTap: () {
              Navigator.pop(context);
              _showCalculationOptions(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              // Navegar para a página de configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              
            },
          )
        ]
      ),
    );
  }
  void _showCalculationOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), 
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calculate, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8), // Espaçamento entre ícone e texto
                      const Text(
                        'Escolha um tipo',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fechar o pop-up
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOptionTile(
                      context,
                      "Cálculo de Inclinação",
                      Icons.text_rotation_angleup_outlined, // Ícone para o cálculo de inclinação
                      () {
                        Navigator.pop(context); // Fecha o diálogo
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Calculoinclinacao()),
                        );
                      },
                    ),
                    _buildOptionTile(
                      context,
                      "Cálculo Estrutural",
                      Icons.build, // Ícone para cálculo estrutural
                      () {
                        Navigator.pop(context); // Fecha o diálogo
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    _buildOptionTile(
                      context,
                      "Cálculo de Viga",
                      Icons.house, // Ícone para cálculo de viga
                      () {
                        Navigator.pop(context); // Fecha o diálogo
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        onTap: onTap,
        tileColor: Theme.of(context).primaryColor.withOpacity(0.05), // Cor de fundo das opções
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Adicionando sombra
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }

}
