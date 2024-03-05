// ignore_for_file: avoid_print

import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/modelo_aspectos.dart';
import 'package:com_celesoft_notasieo/modelo_notas_full.dart';
import 'package:com_celesoft_notasieo/widgets/aspectos_notas_docente.dart';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:com_celesoft_notasieo/widgets/custom_footer.dart';
import 'package:com_celesoft_notasieo/widgets/error_internet.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final List<MAspectos> aspectos;
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
      required this.year,
      required this.aspectos})
      : super(key: key);

  @override
  State<NotasDocenteIndividuales> createState() =>
      _NotasDocenteIndividualesState();
}

class _NotasDocenteIndividualesState extends State<NotasDocenteIndividuales> {
  List<KeyValuePair> anotas = [];
  bool isvalid = true;
  bool cargandoAspectos = false;
  double valoracion = 0;
  final TextEditingController controller = TextEditingController(text: "");
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

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              bool txtAspecto = subtitle != "";
              return AlertDialog(
                backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                title: Column(
                  children: [
                    Text(title),
                    Text(subtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.blue))
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        double valor = 0;
                        if (value.isEmpty) {
                          isvalid = false;
                          setState(() {});
                          return;
                        }
                        try {
                          valor = double.parse(value);
                        } catch (e) {
                          print(e);
                        }
                        if (valor.isNaN) {
                          isvalid = false;
                          setState(() {});
                          return;
                        }
                        if (valor >= 1 && valor <= 5) {
                          isvalid = true;
                        } else {
                          isvalid = false;
                        }
                        setState(() {});
                      },

                      keyboardType:
                          TextInputType.number, // Tipo de teclado numérico
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorText: !isvalid
                            ? "El valor ingresado no está permitido"
                            : "",
                        errorBorder: OutlineInputBorder(
                          borderSide: !isvalid
                              ? const BorderSide(color: Colors.red)
                              : const BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    Text(
                      !txtAspecto ? 'Falta el aspecto' : '',
                      style: const TextStyle(color: Colors.red),
                    )
                  ],
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
                  ElevatedButton(
                    onPressed: () {
                      if (isvalid) {
                        Navigator.pop(context, controller.text);
                        completer.complete(controller.text);
                      }
                    },
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }).then((value) {});
    return completer.future;
  }

  double calcularValoracion() {
    double result = 0;
    List<KeyValuePair> valoresNotas = widget.keyValuePairs
        .where((element) =>
            element.key != "Nombres" && element.key.startsWith('N'))
        .toList();
    List<KeyValuePair> valoresPorcentajes = widget.keyValuePairs
        .where((element) => element.key.startsWith('porcentaje'))
        .toList();
    bool porcentajes = false;
    for (KeyValuePair porcentaje in valoresPorcentajes) {
      if (porcentaje.value != '0' && porcentaje.value != null) {
        porcentajes = true;
        break;
      }
    }
    int cantidadNotas = 0;
    for (int i = 0; i <= 11; i++) {
      late double nota;
      late double porcentaje;
      try {
        nota = double.tryParse(valoresNotas[i].value) ?? 0;
      } catch (e) {
        nota = 0;
      }
      try {
        String strp = valoresPorcentajes[i].value ?? '';
        porcentaje = double.tryParse(strp) ?? 0;
      } catch (e) {
        porcentaje = 0;
      }
      if (porcentajes) {
        result += nota * 0.01 * porcentaje;
      } else {
        result += nota;
        if (nota != 0) cantidadNotas++;
      }
    }
    return (cantidadNotas > 0 ? result / cantidadNotas : result);
  }

  Future<List<Map<String, dynamic>>> obtenerAspectos() async {
    if (mounted) {
      cargandoAspectos = true;
      setState(() {});
    }
    final url = Uri.parse('$urlbase/obtenerAspectosIndividuales.php');
    final bodyAspectos = json.encode({
      'docente': widget.docente,
      'asignatura': widget.asignatura,
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
      cargandoAspectos = false;
      if (mounted) {
        setState(() {});
      }
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
              widget.notasFullModelo.valoracion = widget.keyValuePairs[2].value;
              var a = widget.notasFullModelo.toMap().map((key, value) {
                if (key.startsWith("nota")) {
                  int indiceNota = widget.keyValuePairs
                      .indexWhere((element) => obtenerNota(element.key) == key);
                  String nota = widget.keyValuePairs[indiceNota].value ?? '';
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
      bottomNavigationBar: CustomFooter(
        info: Text(
          widget.nombres,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        extInfo: Text(
          '${widget.asignatura} ${widget.grado}',
          style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
        textInfo: Text(
          widget.periodo,
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        valor: Text(ss
          widget.keyValuePairs[2].value,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: valoracion < 3 ? Colors.red.shade600 : Colors.green),
        ),
      ),
      body: ListView.builder(
        itemCount: anotas.length,
        itemBuilder: (context, index) {
          /* if (index == 0) {
            String valor = widget.keyValuePairs[2].value ?? '0';
            valoracion = double.parse(valor);
            return Card(
              color: Theme.of(context).focusColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              elevation: 7,
              margin: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.keyValuePairs[1].value,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Text(
                            'Valoracion:',
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            widget.keyValuePairs[2].value,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: valoracion < 3
                                    ? Colors.red.shade600
                                    : Colors.greenAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Expanded(child: Text('')),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.periodo,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigoAccent),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else */
          {
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
            int indicePorcentaje = widget.keyValuePairs
                .indexWhere((element) => element.key == 'porcentaje$numero');
            String fechaNota =
                widget.keyValuePairs[indiceFechaNota].value ?? '';
            String sNota = widget.keyValuePairs[indiceNota].value ?? '';
            String strNota = sNota != "" ? sNota.trim() : "";
            double laNota = double.parse(strNota != "" ? strNota : "0");

            String aspecto = widget.keyValuePairs[indiceAnotacion].value ?? '';
            String porcentaje =
                widget.keyValuePairs[indicePorcentaje].value ?? '';
            if (aspecto == '') {
              if (numero <= widget.aspectos.length) {
                aspecto = widget.aspectos[numero - 1].aspecto;
              }
            }

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
                        child: Text(aspecto,
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
                            controller.text =
                                widget.keyValuePairs[indiceNota].value ?? '';
                            // Handle button press
                            String result = await showNumberDialog(
                                context,
                                'Nota $numero',
                                widget.keyValuePairs[indiceAnotacion].value ??
                                    '',
                                widget.keyValuePairs[indiceNota].value ?? '',
                                indiceNota);
                            print(result);
                            widget.keyValuePairs[indiceNota].value = result;
                            double valorac = calcularValoracion();
                            widget.keyValuePairs[2].value =
                                valorac.toStringAsFixed(1);
                            valoracion = valorac;
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha: $fechaNota'),
                          Text(
                            porcentaje != '' ? 'Porcentaje: $porcentaje' : '',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ));
          }
        },
      ),
    );
  }
}
