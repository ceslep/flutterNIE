import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String urlbase = 'https://app.iedeoccidente.com';

class Aspectos {
  String docente;
  String grado;
  String periodo;
  String asignatura;
  String aspecto;
  String porcentaje;
  String fecha;
  String nota;
  TextEditingController aspectoController;
  TextEditingController porcentajeController;
  TextEditingController fechaController;

  Aspectos(
      this.docente,
      this.grado,
      this.periodo,
      this.asignatura,
      this.aspecto,
      this.porcentaje,
      this.fecha,
      this.nota,
      this.aspectoController,
      this.porcentajeController,
      this.fechaController);
}

String toJson(Aspectos aspecto) {
  return '{'
      '"docente": "${aspecto.docente}",'
      '"grado": "${aspecto.grado}",'
      '"periodo": "${aspecto.periodo}",'
      '"asignatura": "${aspecto.asignatura}",'
      '"aspecto": "${aspecto.aspecto}",'
      '"porcentaje": "${aspecto.porcentaje}",'
      '"fecha": "${aspecto.fecha}",'
      '"nota": ${aspecto.nota}'
      '}';
}

class AspectosNotasDocente extends StatefulWidget {
  final String docente;
  final String grado;
  final String asignatura;
  final String periodo;
  const AspectosNotasDocente(
      {Key? key,
      required this.docente,
      required this.grado,
      required this.asignatura,
      required this.periodo})
      : super(key: key);

  @override
  State<AspectosNotasDocente> createState() => _AspectosNotasDocenteState();
}

class _AspectosNotasDocenteState extends State<AspectosNotasDocente> {
  List<Aspectos> aspectos = [];
  var _selectedDate = DateTime.now();
  bool guardando = false;

  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    for (int i = 0; i < 12; i++) {
      aspectos.add(Aspectos(
          widget.docente,
          widget.grado,
          widget.periodo,
          widget.asignatura,
          "",
          "",
          "",
          (i + 1).toString(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController()));
    }
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Aspectos almacenados correctamente"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
    );
  }

  Future<bool> guardarAspectos(json) async {
    final url = Uri.parse('$urlbase/guardarAspectosIndividuales.php');
    final response = await http.post(url, body: json);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (kDebugMode) {
        print(result['msg']);
      }
      return result['msg'] == 'exito';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.amberAccent,
        title: const Text("Configuración de aspectos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              guardando = true;
              setState(() {});
              String json = '[';
              for (var aspecto in aspectos) {
                json += '${toJson(aspecto)},';
              }
              json =
                  json.substring(0, json.length - 1); // Eliminar la última coma
              json += ']';

              if (await guardarAspectos(json)) {
                if (kDebugMode) {
                  print("guardado");
                }
              }
              guardando = false;
              setState(() {});
              _showToast();
            },
            child: !guardando
                ? const Icon(Icons.save, color: Colors.amberAccent)
                : const SpinKitCircle(
                    color: Colors.white, // Color de la animación
                    size: 30.0,
                  ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: aspectos.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('Aspecto ${index + 1}'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  onChanged: (value) {
                    aspectos[index].aspecto =
                        aspectos[index].aspectoController.text;
                    aspectos[index].nota = (index + 1).toString();
                    if (kDebugMode) {
                      print({'oc': value});
                      print({"aspecto": aspectos[index].aspecto});
                    }
                  },
                  controller: aspectos[index].aspectoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Descripción del Aspecto ${index + 1}",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Permite solo números
                  ],
                  onChanged: (value) {
                    if (kDebugMode) {
                      aspectos[index].porcentaje =
                          aspectos[index].porcentajeController.text;
                      print({'oc': value});
                      print({"porcentaje": aspectos[index].porcentaje});
                    }
                  },
                  controller: aspectos[index].porcentajeController,
                  decoration: InputDecoration(
                    labelText: "Porcentaje del Aspecto ${index + 1}",
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      if (kDebugMode) {
                        aspectos[index].porcentaje =
                            aspectos[index].porcentajeController.text;
                        print({'oc': value});
                        print({"porcentaje": aspectos[index].porcentaje});
                      }
                    },
                    readOnly: true,
                    controller: aspectos[index].fechaController,
                    decoration: InputDecoration(
                      labelText: 'Fecha del aspecto ${index + 1}',
                      icon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2023, 1, 1),
                            lastDate: DateTime(2024, 12, 31),
                          ).then((date) {
                            aspectos[index].fechaController.text =
                                date.toString().split(' ')[0];
                            aspectos[index].fecha =
                                aspectos[index].fechaController.text;
                            if (kDebugMode) {
                              print(aspectos[index].fecha);
                            }
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
