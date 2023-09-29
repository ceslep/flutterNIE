// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';
import 'dart:convert';
import 'dart:typed_data';

class ConvivenciaDetallado extends StatefulWidget {
  final ModeloConvivencia detalleConvivencia;
  const ConvivenciaDetallado({Key? key, required this.detalleConvivencia})
      : super(key: key);

  @override
  _ConvivenciaDetalladoState createState() => _ConvivenciaDetalladoState();
}

class _ConvivenciaDetalladoState extends State<ConvivenciaDetallado> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detalle = widget.detalleConvivencia;
    final String base64Image = detalle.firma;
    Uint8List bytes = base64Decode(base64Image.split(',').last);
    print({'image': bytes});
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent)),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Falta'),
              const SizedBox(width: 10),
              Text(detalle.tipoFalta),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                const TituloDetalle(titulo: 'Reportado por el Docente'),
                Detalle(
                  detalleConvivencia: detalle.nombresDocente,
                ),
                const TituloDetalle(titulo: 'Faltas al manual de Convivencia'),
                Detalle(
                  detalleConvivencia: detalle.faltas,
                ),
                const TituloDetalle(titulo: 'Descripción de la Situación'),
                Detalle(detalleConvivencia: detalle.descripcionSituacion),
                const TituloDetalle(titulo: 'Descargos del estudiante'),
                Detalle(detalleConvivencia: detalle.descargosEstudiante),
              ],
            ),
            bytes.isNotEmpty ? Image.memory(bytes) : const SizedBox(width: 10)
          ],
        ),
      ),
    );
  }
}

class Detalle extends StatefulWidget {
  final String detalleConvivencia;
  const Detalle({
    super.key,
    required this.detalleConvivencia,
  });

  @override
  State<Detalle> createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.detalleConvivencia,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}

class TituloDetalle extends StatefulWidget {
  final String titulo;
  const TituloDetalle({super.key, required this.titulo});

  @override
  State<TituloDetalle> createState() => _TituloDetalleState();
}

class _TituloDetalleState extends State<TituloDetalle> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(widget.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
