// ignore_for_file: avoid_print

import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/modelo_notas_full.dart';
import 'package:com_celesoft_notasieo/widgets/aspectos_notas_docente.dart';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'dart:async';

String obtenerNota(String numeroNota) {
  switch (numeroNota) {
    case "N1":
      return "nota1";
    case "N2":
      return "nota2";
    case "N3":
      return "nota3";
    case "N4":
      return "nota4";
    case "N5":
      return "nota5";
    case "N6":
      return "nota6";
    case "N7":
      return "nota7";
    case "N8":
      return "nota8";
    case "N9":
      return "nota9";
    case "N10":
      return "nota10";
    case "N11":
      return "nota11";
    case "N12":
      return "nota12";
    default:
      return "No se encontró una nota para $numeroNota";
  }
}

class NotasDocenteIndividuales extends StatefulWidget {
  final List<KeyValuePair> keyValuePairs;
  final ModeloNotasFull notasFullModelo;
  final String docente;
  final String grado;
  final String asignatura;
  final String nombres;
  final String periodo;
  final String year;

  const NotasDocenteIndividuales(
      {Key? key,
      required this.keyValuePairs,
      required this.docente,
      required this.grado,
      required this.asignatura,
      required this.nombres,
      required this.notasFullModelo,
      required this.periodo,
      required this.year})
      : super(key: key);

  @override
  State<NotasDocenteIndividuales> createState() =>
      _NotasDocenteIndividualesState();
}

class _NotasDocenteIndividualesState extends State<NotasDocenteIndividuales> {
  List<KeyValuePair> anotas = [];
  @override
  void initState() {
    super.initState();
    inicio();
  }

  void inicio() {
    anotas = widget.keyValuePairs
        .where(
          (element) =>
              element.key.contains("N") && !element.key.contains("Nombres"),
        )
        .toList();
  }

  void mostrarAlert(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          key: const Key('alert'),
          title: title,
          content: text,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<String> showNumberDialog(BuildContext context, String title,
      String subtitle, String value, int indice) async {
    Completer<String> completer = Completer();
    final TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(title),
              Text(subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.blue))
            ],
          ),
          content: TextField(
            keyboardType: TextInputType.number, // Tipo de teclado numérico
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, "-1");
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
                completer.complete(controller.text);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((value) {
      if ((value != null) &&
          (value != "") &&
          (value != " ") &&
          (value != "-1")) {
        double val = double.parse(value);
        if ((val > 5) || (val < 1)) {
          mostrarAlert(context, 'Error en la nota', 'Valor no permitido');
        } else {
          // Procesar el valor ingresado
          widget.keyValuePairs[indice].value = value;
        }
      } else {
        if (value != "-1") {
          mostrarAlert(
              context, 'Error en el valor', 'No puede estar en blanco');
        }
      }
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    inicio();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        foregroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.nombres, style: const TextStyle(fontSize: 12)),
            Text('${widget.asignatura} ${widget.grado}',
                style: const TextStyle(fontSize: 12, color: Colors.white))
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, {"dataNDI": "previous"}),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {"dataNDI": "home"});
            },
            child: const Icon(Icons.home, color: Colors.white),
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
                    ),
                  ));
            },
            child: const Icon(Icons.note_alt_outlined, color: Colors.yellow),
          ),
          TextButton(
            onPressed: () {
              int indiceEstudiante = widget.keyValuePairs
                  .indexWhere((element) => element.key == "estudiante");
              String estudiante = widget.keyValuePairs[indiceEstudiante].value;
              print({"eskp": estudiante});
              print({"esnfm": widget.notasFullModelo.estudiante});
              widget.notasFullModelo.toMap().forEach((key, value) {
                print({"$key:$value"});
              });
              var a = widget.notasFullModelo.toMap().map((key, value) {
                if (key.startsWith("nota")) {
                  int indiceNota = widget.keyValuePairs
                      .indexWhere((element) => obtenerNota(element.key) == key);
                  String nota = widget.keyValuePairs[indiceNota].value;
                  value = nota;
                }
                return MapEntry(key, value);
              });
              print(a);
            },
            child: const Icon(Icons.save, color: Colors.black87),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: anotas.length,
        itemBuilder: (context, index) {
          KeyValuePair data = anotas[index];
          String str = data.key;

          int indiceNumero = str.indexOf(RegExp(r'\d'));
          String numeroStr = str.substring(indiceNumero);

          int numero = int.parse(numeroStr);

          int indiceNota = widget.keyValuePairs
              .indexWhere((element) => element.key == 'N$numero');
          int indiceAnotacion = widget.keyValuePairs
              .indexWhere((element) => element.key == 'aspecto$numero');
          int indiceFechaNota = widget.keyValuePairs
              .indexWhere((element) => element.key == 'fecha$numero');
          String fechaNota = widget.keyValuePairs[indiceFechaNota].value ?? '';
          String strNota = widget.keyValuePairs[indiceNota].value.trim();
          double laNota = double.parse(strNota != "" ? strNota : "0");

          return Card(
              child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              'Nota $numero',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 0.65 * MediaQuery.of(context).size.width,
                      child: Text(
                          widget.keyValuePairs[indiceAnotacion].value ?? '',
                          style: const TextStyle(color: Colors.green)),
                    ),
                    const SizedBox(
                        width: 27), // Add Spacer to fill remaining space
                    SizedBox(
                      height: 40,
                      width: 55,
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amberAccent),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.black)),
                        onPressed: () async {
                          // Handle button press
                          String result = await showNumberDialog(
                              context,
                              'Nota $numero',
                              widget.keyValuePairs[indiceAnotacion].value ?? '',
                              widget.keyValuePairs[indiceNota].value ?? '',
                              indiceNota);
                          print(result);
                          widget.keyValuePairs[indiceNota].value = result;
                          setState(() {});
                        },
                        child: Text(laNota != 0 ? laNota.toString() : '',
                            style: TextStyle(
                                color: laNota < 3 ? Colors.red : Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('Fecha: $fechaNota')],
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}
