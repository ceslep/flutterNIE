// ignore_for_file: avoid_print

import 'package:com_celesoft_notasieo/modelo_aspectos.dart';
import 'package:com_celesoft_notasieo/widgets/custom_footer.dart';
import 'package:com_celesoft_notasieo/widgets/error_internet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  String year;
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
      this.year,
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
      '"nota": "${aspecto.nota}",'
      '"year": "${aspecto.year}"'
      '}';
}

class AspectosNotasDocente extends StatefulWidget {
  final String docente;
  final String grado;
  final String asignatura;
  final String periodo;
  final String year;
  final bool obteniendo;
  const AspectosNotasDocente(
      {super.key,
      required this.docente,
      required this.grado,
      required this.asignatura,
      required this.periodo,
      required this.year,
      required this.obteniendo});

  @override
  State<AspectosNotasDocente> createState() => _AspectosNotasDocenteState();
}

class _AspectosNotasDocenteState extends State<AspectosNotasDocente> {
  List<Aspectos> aspectos = [];
  var _selectedDate = DateTime.now();
  bool guardando = false;
  bool cargandoAspectos = false;
  List<MAspectos> maspectos = [];
  late FToast fToast;
  bool obteniendo = false;
  double _totalPorcentaje = 0;

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
  void initState() {
    obteniendo = widget.obteniendo;
    super.initState();
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
          widget.year,
          TextEditingController(),
          TextEditingController(),
          TextEditingController()));
    }

    fToast = FToast();
    fToast.init(context);
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
          Text(
            "Aspectos almacenados correctamente",
            style: TextStyle(fontSize: 10),
          ),
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
    } else {
      // ignore: use_build_context_synchronously
      String resultado = await errorInternet(
          context,
          "Error ${response.statusCode}",
          "Se ha presentado un error de Intertet");
      print(resultado);
    }
    return false;
  }

  double _calcularPorcentaje(List<MAspectos> aspectos) {
    double porcentaje = aspectos
        .map((e) => double.parse(e.porcentaje != "" ? e.porcentaje : '0'))
        .reduce((value, porcentaje) => value + porcentaje);
    return porcentaje;
  }

  void asignarAspectos(List<Map<String, dynamic>> jsonData) {
    maspectos = jsonData.map((json) => MAspectos.fromJson(json)).toList();
    for (var maspecto in maspectos) {
      int indiceAspecto = int.parse(maspecto.nota) - 1;
      aspectos[indiceAspecto].aspectoController.text = maspecto.aspecto;
      aspectos[indiceAspecto].porcentajeController.text = maspecto.porcentaje;
      aspectos[indiceAspecto].fechaController.text = maspecto.fecha;
      if (mounted) {
        setState(() {
          // State update code here
        });
      }
    }
    _totalPorcentaje = _calcularPorcentaje(maspectos);
    if (mounted) {
      setState(() {});
    }
  }

  bool porcentajeValido(String porcentaje) {
    double valor = 0;
    bool isvalid = true;
    if (porcentaje == "") return true;
    try {
      valor = double.parse(porcentaje);
    } catch (e) {
      print(e);
    }
    if (valor.isNaN) {
      isvalid = false;

      return isvalid;
    }
    if (valor > 0 && valor <= 100) {
      isvalid = true;
    } else {
      isvalid = false;
    }
    // if (mounted) setState(() {});
    return isvalid;
  }

  @override
  Widget build(BuildContext context) {
    if (obteniendo) {
      obteniendo = false;
      obtenerAspectos().then(
        (jsonData) {
          asignarAspectos(jsonData);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.amberAccent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Configuración de aspectos",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.asignatura,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.grado,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              guardando = true;
              setState(() {});
              String json = '[';
              int index = 0;
              for (var aspecto in aspectos) {
                if (aspecto.aspecto != "") {
                  if (aspecto.fecha == "") {
                    final DateTime now = DateTime.now();
                    aspecto.fecha = DateFormat('yyyy-MM-dd').format(now);
                  }
                  json += '${toJson(aspecto)},';
                } else {
                  aspecto.aspecto = maspectos[index].aspecto;
                  aspecto.porcentaje = maspectos[index].porcentaje;
                  aspecto.fecha = maspectos[index].fecha;
                  json += '${toJson(aspecto)},';
                }
                index++;
              }
              json =
                  json.substring(0, json.length - 1); // Eliminar la última coma
              json += ']';
              print(json);
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
      bottomNavigationBar: CustomFooter(
        info: const Text(
          'Porcentajes',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        extInfo: Text(
          '${widget.asignatura} ${widget.grado}',
          style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 10),
        ),
        textInfo: Text(
          'Total: ${_totalPorcentaje.toString()}',
          style: const TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        valor: const Text(
          '',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.green),
        ),
        gradiente: const LinearGradient(
          colors: [Colors.white, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: ListView.builder(
        itemCount: aspectos.length,
        itemBuilder: (context, index) {
          bool boldAspecto = aspectos[index].aspectoController.text != "";
          bool porcentajeval = true;

          if (maspectos.isNotEmpty) {
            try {
              porcentajeval = porcentajeValido(maspectos[index].porcentaje);
            } catch (e) {
              print(e);
            }
          }

          return ExpansionTile(
            title: Row(
              children: [
                Text('Aspecto ${index + 1}',
                    style: TextStyle(
                        fontWeight:
                            boldAspecto ? FontWeight.bold : FontWeight.normal)),
                boldAspecto
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    : const SizedBox(),
              ],
            ),
            subtitle: Text(aspectos[index].aspectoController.text,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                )),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                child: TextField(
                  onChanged: (value) {
                    aspectos[index].aspecto =
                        aspectos[index].aspectoController.text;
                    maspectos[index].aspecto = value;
                    aspectos[index].nota = (index + 1).toString();
                  },
                  controller: aspectos[index].aspectoController,
                  maxLines: 3,
                  style: TextStyle(
                      color: boldAspecto ? Colors.blue : Colors.black),
                  decoration: InputDecoration(
                      fillColor:
                          boldAspecto ? Colors.lightBlue.shade50 : Colors.white,
                      filled: true,
                      labelText: "Descripción del Aspecto ${index + 1}",
                      border: const OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Permite solo números
                  ],
                  onChanged: (value) {
                    print(value);

                    // if (mounted) setState(() {});
                    aspectos[index].porcentajeController.text = value;
                    aspectos[index].porcentaje = value;
                    maspectos[index].porcentaje = value;
                    _totalPorcentaje = _calcularPorcentaje(maspectos);
                    setState(() {});
                  },
                  controller: aspectos[index].porcentajeController,
                  decoration: InputDecoration(
                    labelText: "Porcentaje del Aspecto ${index + 1}",
                    labelStyle: TextStyle(
                        color: !porcentajeval ? Colors.red : Colors.black),
                    errorText: !porcentajeval
                        ? "El porcentaje ingresado no está permitido"
                        : "",
                    errorBorder: OutlineInputBorder(
                      borderSide: !porcentajeval
                          ? const BorderSide(color: Colors.red)
                          : const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      print(value);
                      aspectos[index].fechaController.text = value;
                      aspectos[index].fecha = value;
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
                            firstDate: DateTime(2024, 1, 1),
                            lastDate: DateTime(2099, 12, 31),
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
