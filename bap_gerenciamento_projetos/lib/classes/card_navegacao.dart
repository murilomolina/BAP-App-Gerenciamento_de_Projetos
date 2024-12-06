import 'package:flutter/material.dart';

class CardNavegacao extends StatelessWidget {
  final String titulo;
  final Widget paginaDestino;
  final String cardType;

  const CardNavegacao({super.key, required this.titulo, required this.paginaDestino, required this.cardType});

  @override
  Widget build(BuildContext context) {
    return cardType == 'projetos' ? Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordas arredondadas
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 157, 193, 255),
              Theme.of(context).primaryColor
            ], // Gradiente de fundo
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(15), // Mantendo as bordas arredondadas
        ),
        width: 120, 
        height: 120,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título em destaque
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16, // diminiundo o tamanho da fonte
                fontWeight: FontWeight.bold,
                color: Colors.white, // Mudando a cor do texto para branco
              ),
            ),
            // Botão para navegar
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => paginaDestino),
                );
              },
              child: const Text(
                'Navegar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // diminiundo o tamanho da fonte do botão
                ),
              ),
            ),
          ],
        ),
      ),
    ):
    Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordas arredondadas
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient:  const LinearGradient(
            colors: [
              Color.fromARGB(255, 157, 193, 255),
              Color.fromARGB(255, 252, 252, 252), 
            ], // Gradiente de fundo
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(15), // Mantendo as bordas arredondadas
        ),
        width: 120, 
        height: 120,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título em destaque
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14, // Aumentando o tamanho da fonte
                fontWeight: FontWeight.bold,
                color: Colors.black, // Mudando a cor do texto para branco
              ),
            ),
            // Botão para navegar
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => paginaDestino),
                );
              },
              child: const Text(
                'Navegar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // Aumentando o tamanho da fonte do botão
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}