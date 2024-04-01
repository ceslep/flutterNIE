// ignore_for_file: avoid_print

import 'package:com_celesoft_notasieo/modelo_aspectos.dart';
import 'package:com_celesoft_notasieo/modelo_notas_full.dart';
import 'package:com_celesoft_notasieo/widgets/error_internet.dart';
import 'package:com_celesoft_notasieo/widgets/notas_docente.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

const String urlbase = 'https://app.iedeoccidente.com';

class AsignaturasDocente extends StatefulWidget {
  final List<String> asignaturas;
  final String grado;
  final String nivel;
  final String numero;
  final String docente;
  final String nombresDocente;
  final String asignacion;
  final String periodo;
  final String year;

  const AsignaturasDocente(
      {super.key,
      required this.asignaturas,
      required this.docente,
      required this.grado,
      required this.nivel,
      required this.numero,
      required this.nombresDocente,
      required this.asignacion,
      required this.periodo,
      required this.year});

  @override
  State<AsignaturasDocente> createState() => _AsignaturasDocenteState();
}

class _AsignaturasDocenteState extends State<AsignaturasDocente> {
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> notasFull = [];
  List<ModeloNotasFull> notasFullModelo = [];
  List<Map<String, dynamic>> aspectosJSON = [];
  List<MAspectos> maspectos = [];
  bool consultando = false;
  String aasignatura = "";
  Future<List<Map<String, dynamic>>> getNotas(String asignatura) async {
    consultando = true;
    aasignatura = asignatura;
    setState(() {});
    const String urlbase = 'https://app.iedeoccidente.com';
    if (kDebugMode) {
      print({"asignatura": asignatura});
    }
    final url = Uri.parse('$urlbase/getNotas.php');
    final bodyData = json.encode({
      'docente': widget.docente,
      'asignacion': widget.asignacion,
      'nivel': widget.nivel,
      'numero': widget.numero,
      'asignatura': asignatura,
      'periodo': widget.periodo
    });
    if (kDebugMode) {
      print({"bodyData", bodyData});
    }
    try {
      final response = await http.post(url, body: bodyData);

      if (kDebugMode) {
        print(response.statusCode);
      }
      consultando = false;
      aasignatura = "";
      setState(() {});
      if (response.statusCode == 200) {
        notas = jsonDecode(response.body).cast<Map<String, dynamic>>();
        notas.sort(
          (a, b) => a['Nombres'].compareTo(b['Nombres']),
        );
        return notas;
      } else {
        // ignore: use_build_context_synchronously
        String result = await errorInternet(
            context,
            "Error ${response.statusCode}",
            "Se ha presentado un error de Internet");
        if (result == "volver") {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      }
    } catch (e) {
      AlertDialog(
          title: const Text("Hay un error al obtener los datos"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ]);
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> getNotasFull(String asignatura) async {
    consultando = true;
    aasignatura = asignatura;
    setState(() {});
    const String urlbase = 'https://app.iedeoccidente.com';
    if (kDebugMode) {
      print({"asignatura": asignatura});
    }
    final url = Uri.parse('$urlbase/getNotasFull.php');
    final bodyData = json.encode({
      'docente': widget.docente,
      'asignacion': widget.asignacion,
      'grado': widget.grado,
      'asignatura': asignatura,
      'periodo': widget.periodo,
      'year': widget.year
    });
    if (kDebugMode) {
      print({"bodyData", bodyData});
    }
    try {
      final response = await http.post(url, body: bodyData);

      if (kDebugMode) {
        print(response.statusCode);
      }
      consultando = false;
      aasignatura = "";
      setState(() {});
      if (response.statusCode == 200) {
        notasFull = jsonDecode(response.body).cast<Map<String, dynamic>>();
        return notasFull;
      } else {
        // ignore: use_build_context_synchronously
        String result = await errorInternet(
            context,
            "Error ${response.statusCode}",
            "Se ha presentado un error de Internet en getNotasFull");
        if (result == "volver") {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      }
    } catch (e) {
      AlertDialog(
          title: const Text("Hay un error al obtener los datos"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Aceptar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ]);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> obtenerAspectos(asignatura) async {
    final url = Uri.parse('$urlbase/obtenerAspectosIndividuales.php');
    final bodyAspectos = json.encode({
      'docente': widget.docente,
      'asignatura': asignatura,
      'periodo': widget.periodo,
      'year': widget.year,
      'grado': widget.grado,
    });
    final response = await http.post(url, body: bodyAspectos);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final dataAspectos = jsonResponse as List<dynamic>;
      final listaAspectos =
          dataAspectos.map((item) => item as Map<String, dynamic>).toList();
      return listaAspectos;
    } else {
      // ignore: use_build_context_synchronously
      String result = await errorInternet(
          context,
          "Error ${response.statusCode}",
          "Se ha presentado un error de Intertet");
      if (result == "volver") {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title:
              Text(widget.nombresDocente, style: const TextStyle(fontSize: 14)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(
              context,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, {"data": "home"}),
              child: const Icon(Icons.home, color: Colors.lightGreenAccent),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: widget.asignaturas.length,
            itemBuilder: (context, index) {
              String asignatura = widget.asignaturas[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.description),
                ),
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.asignaturas[index],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          getNotas(asignatura).then((value) {
                            notas = value;
                            getNotasFull(asignatura).then((valueNF) async {
                              notasFull = valueNF;
                              obtenerAspectos(asignatura).then(
                                (value) async {
                                  aspectosJSON = value;
                                  notasFullModelo = notasFull
                                      .map((jsonNota) =>
                                          ModeloNotasFull.fromJson(jsonNota))
                                      .toList();
                                  print(notasFullModelo);
                                  maspectos = aspectosJSON
                                      .map(
                                        (aspectoJSON) =>
                                            MAspectos.fromJson(aspectoJSON),
                                      )
                                      .toList();
                                  if (notas.isNotEmpty ||
                                      notasFullModelo.isNotEmpty) {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotasDocente(
                                          notas: notas,
                                          notasFullModelo: notasFullModelo,
                                          asignatura: asignatura,
                                          grado: widget.grado,
                                          docente: widget.docente,
                                          periodo: widget.periodo,
                                          year: widget.year,
                                          maspectos: maspectos,
                                        ),
                                      ),
                                    );
                                    if (result['dataND'] == "home") {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context, {"data": "home"});
                                    }
                                  }
                                },
                              );
                            });
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.grado),
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(''),
                            ),

                            consultando &&
                                    aasignatura == widget.asignaturas[index]
                                ? const SpinKitChasingDots(
                                    color:
                                        Colors.yellow, // Color de la animación
                                    size: 15.0,
                                  )
                                : const Icon(Icons.cloud_download), // )
                          ],
                        ))
                  ],
                ),
                subtitle: const Divider(),
              );
            }));
  }
}
