// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_notas.dart';

class NotasDetalladas extends StatefulWidget {
  final List<ModeloNotas> detalleNotas;
  const NotasDetalladas({Key? key, required this.detalleNotas})
      : super(key: key);

  @override
  State<NotasDetalladas> createState() => _NotasDetalladasState();
}

class _NotasDetalladasState extends State<NotasDetalladas> {
  late List<ModeloNotas> notasDetalladas;
  @override
  void initState() {
    super.initState();
    notasDetalladas = widget.detalleNotas;
    print(notasDetalladas[0].asignatura);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent)),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Detallado de Notas'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.lightBlueAccent,
          ),
          body: Text(notasDetalladas[0].asignatura),
        ));
  }
}
