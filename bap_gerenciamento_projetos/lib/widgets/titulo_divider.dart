import 'package:flutter/material.dart';

Widget tituloDivider(BuildContext context, String titulo) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calcula o comprimento do Divider como 80% da largura do título
            double dividerWidth = constraints.maxWidth * 0.5;

            return Divider(
              thickness: 2,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              indent: (constraints.maxWidth - dividerWidth) / 2,
              endIndent: (constraints.maxWidth - dividerWidth) / 2,
            );
          },
        ),
      ],
    );
  }