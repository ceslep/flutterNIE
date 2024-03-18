// ignore_for_file: avoid_print

import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/modelo_aspectos.dart';
import 'package:com_celesoft_notasieo/modelo_notas_full.dart';
import 'package:com_celesoft_notasieo/widgets/aspectos_notas_docente.dart';
import 'package:com_celesoft_notasieo/widgets/notas_docente_individuales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotasDocente extends StatefulWidget {
  final List<Map<String, dynamic>> notas;
  final List<ModeloNotasFull> notasFullModelo;
  final List<MAspectos> maspectos;

  final String asignatura;
  final String grado;
  final String docente;
  final String periodo;
  final String year;
  const NotasDocente({
    super.key,
    required this.notas,
    required this.asignatura,
    required this.grado,
    required this.docente,
    required this.periodo,
    required this.year,
    required this.notasFullModelo,
    required this.maspectos,
  });

  @override
  State<NotasDocente> createState() => _NotasDocenteState();
}

class _NotasDocenteState extends State<NotasDocente> {
  late ModeloNotasFull notasVacias;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('${widget.asignatura} ${widget.grado}',
            style: const TextStyle(fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {"dataND": "home"});
            },
            child: const Icon(Icons.home, color: Colors.brown),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AspectosNotasDocente(
                      docente: widget.docente,
                      grado: widget.grado,
                      asignatura: widget.asignatura,
                      periodo: widget.periodo,
                      year: widget.year,
                      obteniendo: true,
                    ),
                  ));
            },
            child: const Icon(Icons.note_alt_outlined, color: Colors.brown),
          ),
          TextButton(
            onPressed: () {},
            child: const Icon(Icons.notes_outlined, color: Colors.brown),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, {"dataND": "previous"}),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.notas.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> nota = widget.notas[index];
            if (kDebugMode) {
              print(nota);
            }
            String nombres = nota['Nombres'];
            String valoracion = nota['Val'] ?? '';
            String estudiante = nota['estudiante'];

            int indiceEstudiante = widget.notasFullModelo
                .indexWhere((element) => element.estudiante == estudiante);

            List<KeyValuePair> keyValuePairs = nota.entries
                .map((entry) => KeyValuePair(entry.key, entry.value))
                .toList();

// Access key-value pairs
            for (var pair in keyValuePairs) {
              if (kDebugMode) {
                print('Key: ${pair.key}, Value: ${pair.value}');
              }
            }
            double val = double.parse(valoracion != '' ? valoracion : '0');
            return Card(
              color: index % 2 == 0
                  ? Colors.lightGreen.shade100
                  : const Color.fromARGB(255, 209, 222, 194),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nombres,
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        Text(estudiante),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      valoracion,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: (val < 3) ? Colors.red : Colors.black),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Icon(Icons.apps),
                          onPressed: () async {
                            ModeloNotasFull notasVacias = ModeloNotasFull(
                                ind: "",
                                estudiante: estudiante,
                                grado: widget.grado,
                                asignatura: widget.asignatura,
                                docente: widget.docente,
                                periodo: widget.periodo,
                                valoracion: valoracion,
                                nota1: "",
                                nota2: "",
                                nota3: "",
                                nota4: "",
                                nota5: "",
                                nota6: "",
                                nota7: "",
                                nota8: "",
                                nota9: "",
                                nota10: "",
                                nota11: "",
                                nota12: "",
                                porcentaje1: "",
                                porcentaje2: "",
                                porcentaje3: "",
                                porcentaje4: "",
                                porcentaje5: "",
                                porcentaje6: "",
                                porcentaje7: "",
                                porcentaje8: "",
                                porcentaje9: "",
                                porcentaje10: "",
                                porcentaje11: "",
                                porcentaje12: "",
                                aspecto1: "",
                                aspecto2: "",
                                aspecto3: "",
                                aspecto4: "",
                                aspecto5: "",
                                aspecto6: "",
                                aspecto7: "",
                                aspecto8: "",
                                aspecto9: "",
                                aspecto10: "",
                                aspecto11: "",
                                aspecto12: "",
                                fecha1: "",
                                fecha2: "",
                                fecha3: "",
                                fecha4: "",
                                fecha5: "",
                                fecha6: "",
                                fecha7: "",
                                fecha8: "",
                                fecha9: "",
                                fecha10: "",
                                fecha11: "",
                                fecha12: "",
                                anotacion1: "",
                                anotacion2: "",
                                anotacion3: "",
                                anotacion4: "",
                                anotacion5: "",
                                anotacion6: "",
                                anotacion7: "",
                                anotacion8: "",
                                anotacion9: "",
                                anotacion10: "",
                                anotacion11: "",
                                anotacion12: "",
                                fechaa1: "",
                                fechaa2: "",
                                fechaa3: "",
                                fechaa4: "",
                                fechaa5: "",
                                fechaa6: "",
                                fechaa7: "",
                                fechaa8: "",
                                fechaa9: "",
                                fechaa10: "",
                                fechaa11: "",
                                fechaa12: "",
                                fechahora: "",
                                year: widget.year);
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotasDocenteIndividuales(
                                    keyValuePairs: keyValuePairs,
                                    notasFullModelo: indiceEstudiante != -1
                                        ? widget
                                            .notasFullModelo[indiceEstudiante]
                                        : notasVacias,
                                    docente: widget.docente,
                                    grado: widget.grado,
                                    asignatura: widget.asignatura,
                                    nombres: nombres,
                                    periodo: widget.periodo,
                                    year: widget.year,
                                    aspectos: widget.maspectos,
                                  ),
                                ));
                            if (result["dataNDI"] == "home") {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, {"dataND": "home"});
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.yellow),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: const Icon(Icons.sick),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Icon(Icons.accessibility),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
