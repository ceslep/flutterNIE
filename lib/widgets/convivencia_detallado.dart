// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:com_celesoft_notasieo/modelo_Convivencia.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

List<String> separarTexto(String texto) {
  List<String> textosSeparados = [];
  final RegExp regex = RegExp(r'\d+\.');

  List<RegExpMatch> matches = regex.allMatches(texto).toList();

  int start = 0;

  for (RegExpMatch match in matches) {
    textosSeparados.add(texto.substring(start, match.start).trim());
    start = match.end;
  }

  if (start < texto.length) {
    textosSeparados.add(texto.substring(start).trim());
  }

  return textosSeparados;
}

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
    final faltas = widget.detalleConvivencia.faltas.replaceAll('Array', '');
    final String base64Image = detalle.firma;
    final bool tipoP = detalle.tipoFalta.startsWith('POSITIVO');
    Uint8List bytes = base64Decode(base64Image.split(',').last);
    List<String> lasfaltas = separarTexto(faltas);

    print(lasfaltas);
    final widgets = [
      Visibility(
          visible: true,
          child: Column(
            children: [
              TituloDetalle(
                  titulo: 'Reportado por el Docente',
                  color: !tipoP ? Colors.red : Colors.green),
              Detalle(
                detalleConvivencia: detalle.nombresDocente,
              ),
            ],
          )),
      Visibility(
          visible: !tipoP,
          child: Column(
            children: [
              const TituloDetalle(titulo: 'Faltas al manual de Convivencia'),
              Column(
                children: lasfaltas
                    .map((falta) => Row(
                          children: [
                            Expanded(
                                child: falta.isNotEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(
                                                        color: Colors.red,
                                                        shadows: [
                                                          Shadow(
                                                              color: Colors.red)
                                                        ],
                                                        size: 18,
                                                        Icons.check_circle),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        falta.substring(0,
                                                            falta.length - 1),
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text('')),
                          ],
                        ))
                    .toList(),
              )
            ],
          )),
      Visibility(
          visible: !tipoP,
          child: Column(
            children: [
              const TituloDetalle(titulo: 'Descripción de la Situación'),
              Detalle(detalleConvivencia: detalle.descripcionSituacion)
            ],
          )),
      Visibility(
          visible: !tipoP,
          child: Column(
            children: [
              const TituloDetalle(titulo: 'Descargos del estudiante'),
              Detalle(detalleConvivencia: detalle.descargosEstudiante)
            ],
          )),
      Visibility(
          visible: tipoP,
          child: Column(
            children: [
              const TituloDetalle(
                  titulo: 'Observación Reportada por el docente',
                  color: Colors.green),
              Detalle(
                detalleConvivencia: detalle.positivos,
              )
            ],
          )),
      bytes.isNotEmpty ? Image.memory(bytes) : const SizedBox(width: 10)
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: tipoP ? Colors.lightGreenAccent : Colors.redAccent)),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              tipoP ? const Text('Reporte') : const Text('Falta'),
              const SizedBox(width: 10),
              Text(detalle.tipoFalta),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: widgets,
          ),
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
  final Color? color;
  const TituloDetalle(
      {super.key, required this.titulo, this.color = Colors.red});

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
            style: TextStyle(color: widget.color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
