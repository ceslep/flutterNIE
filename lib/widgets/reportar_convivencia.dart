// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:com_celesoft_notasieo/widgets/listado_faltas.dart';
import 'package:com_celesoft_notasieo/widgets/signature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

class ReportarConvivencia extends StatefulWidget {
  final String estudiante;
  final String nombres;

  const ReportarConvivencia(
      {super.key, required this.estudiante, required this.nombres});

  @override
  State<ReportarConvivencia> createState() => _ReportarConvivenciaState();
}

class _ReportarConvivenciaState extends State<ReportarConvivencia> {
  final List<DropdownMenuItem> _itemsTipos = [
    const DropdownMenuItem(
      value: '',
      enabled: false,
      child: Text(
        'Seleccione el Tipo de falta',
        style: TextStyle(color: Colors.grey),
      ),
    ),
    const DropdownMenuItem(
      value: 'TIPO I',
      child: Text('Faltas Tipo I'),
    ),
    const DropdownMenuItem(
      value: 'TIPO II',
      child: Text(
        'Faltas Tipo II',
        style: TextStyle(color: Colors.orangeAccent),
      ),
    ),
    const DropdownMenuItem(
      value: 'TIPO III',
      child: Text(
        'Faltas Tipo III',
        style: TextStyle(color: Colors.red),
      ),
    ),
    const DropdownMenuItem(
      value: 'OTRAS',
      child: Text(
        'Otras Observaciones',
        style: TextStyle(color: Colors.green),
      ),
    ),
  ];

  final List<DropdownMenuItem> _itemsHoras = [
    const DropdownMenuItem(
      value: '',
      enabled: false,
      child: Text(
        'Seleccione la hora de la falta',
        style: TextStyle(color: Colors.grey),
      ),
    ),
    const DropdownMenuItem(
      value: 'Primera Hora',
      child: Text('Primera Hora'),
    ),
    const DropdownMenuItem(
      value: 'Segunda Hora',
      child: Text(
        'Segunda Hora',
      ),
    ),
    const DropdownMenuItem(
      value: 'Tercera Hora',
      child: Text(
        'Tercera Hora',
      ),
    ),
    const DropdownMenuItem(
      value: 'Cuarta Hora',
      child: Text(
        'Cuarta Hora',
      ),
    ),
    const DropdownMenuItem(
      value: 'Quinta Hora',
      child: Text(
        'Quinta Hora',
      ),
    ),
    const DropdownMenuItem(
      value: 'Sexta Hora',
      child: Text(
        'Sexta Hora',
      ),
    ),
    const DropdownMenuItem(
      value: 'Séptima Hora',
      child: Text(
        'Séptima Hora',
      ),
    ),
  ];

  List<Map<String, dynamic>> _itemsFaltas = [];
  List<bool> checkeds = [];

  bool consultandoFaltas = false;
  TextEditingController setFaltasController = TextEditingController(text: "");
  TextEditingController setDescripcionFaltaController =
      TextEditingController(text: "");

  TextEditingController setDescacripcionFaltaController =
      TextEditingController(text: "");

  List<String> itemFaltas = [];

  String tipoFalta = '';
  String horaFalta = '';
  String firma = '';
  int descCount = 0;
  int descaCount = 0;

  Future<List<Map<String, dynamic>>> getFaltas(String tipo) async {
    final url = Uri.parse('$urlbase/getItemsConvivencia.php');

    var response = await http.post(url, body: json.encode({'tipo': tipo}));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  Future<void> guardarConvivencia() async {}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convivencia'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.yellowAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signature(),
                    ));

                if (result != null) {
                  if (result['firma'] != '') {
                    setState(() => firma = result['firma']);
                  }
                }
                print(firma);
              },
              icon: const Icon(Icons.edit,
                  color: Color.fromARGB(255, 231, 255, 76)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                GuardaConv(context);
              },
              icon: const Icon(Icons.save, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: 0.85 * MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: DropdownButton(
                        value: tipoFalta,
                        items: _itemsTipos,
                        onChanged: (value) async {
                          tipoFalta = value;
                          setState(
                              () => consultandoFaltas = !consultandoFaltas);
                          _itemsFaltas = await getFaltas(value);
                          setState(
                              () => consultandoFaltas = !consultandoFaltas);
                          itemFaltas = _itemsFaltas
                              .map((e) => e['itemConvivencia']
                                  .toString()
                                  .replaceFirst(RegExp(r'^\d+\.'), '')
                                  .trim())
                              .toList();
                          checkeds =
                              List<bool>.filled(itemFaltas.length, false);
                          await setFaltas(context, itemFaltas);
                        },
                        hint: const Text('Seleccione el tipo de falta'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 0.15 * MediaQuery.of(context).size.width,
                    child: IconButton(
                      onPressed: () async {
                        await setFaltas(context, itemFaltas);
                      },
                      icon: !consultandoFaltas
                          ? const Icon(Icons.visibility)
                          : const SpinKitChasingDots(
                              color: Colors.blue,
                              size: 14,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0.95 * MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  style: const TextStyle(fontSize: 11),
                  maxLines: 3,
                  readOnly: true,
                  controller: setFaltasController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 0.95 * MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownButton(
                  value: horaFalta,
                  items: _itemsHoras,
                  onChanged: (value) {
                    setState(() {
                      horaFalta = value;
                    });
                  },
                  hint: const Text('Seleccione la hora de la falta'),
                ),
              ),
            ),
            SizedBox(
              width: 0.95 * MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción de la Situación presentada',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value) {
                        descCount = value.length;
                        setState(() {});
                      },
                      maxLines: 3,
                      controller: setDescripcionFaltaController,
                      decoration: InputDecoration(
                          hoverColor: Colors.yellow,
                          border: const OutlineInputBorder(),
                          fillColor: Colors.yellow,
                          counter: Text(
                            '${descCount.toString()} de Mínimo  20 Caracteres',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 10),
                          )),
                      autocorrect: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 0.95 * MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descargos del estudiante',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value) {
                        descaCount = value.length;
                        setState(() {});
                      },
                      maxLines: 3,
                      controller: setDescacripcionFaltaController,
                      decoration: InputDecoration(
                          hoverColor: Colors.yellow,
                          border: const OutlineInputBorder(),
                          fillColor: Colors.yellow,
                          counter: Text(
                            '${descaCount.toString()} de Mínimo  20 Caracteres',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 10),
                          )),
                      autocorrect: true,
                    ),
                  ],
                ),
              ),
            ),
            firma != ''
                ? Center(
                    child: Column(
                      children: [
                        Image.memory(
                          // Decodificar la cadena base64 y convertirla en bytes
                          base64Decode(firma),
                          // Puedes ajustar el ancho y alto de la imagen según tus necesidades
                          width: 400,
                          height: 100,
                          // Para ajustar el tamaño de la imagen al contenedor que la contiene, puedes usar fit: BoxFit.contain
                          fit: BoxFit.contain,
                        ),
                        const Text('firma')
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.black),
                    elevation: MaterialStatePropertyAll(Checkbox.width),
                    backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                    foregroundColor: MaterialStatePropertyAll(Colors.yellow)),
                onPressed: () {
                  GuardaConv(context);
                },
                child: SizedBox(
                  width: 0.6 * MediaQuery.of(context).size.width,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Registrar Convivencia'),
                      Icon(
                        Icons.accessibility_new,
                        size: 35,
                        color: Color.fromARGB(255, 254, 204, 221),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void GuardaConv(BuildContext context) {
    if (tipoFalta != "" &&
        horaFalta != "" &&
        descCount >= 20 &&
        descaCount >= 20) {
    } else {
      mostrarAlert(context, 'Convivencia', 'Complete la información');
    }
  }

  Future<void> setFaltas(BuildContext context, List<String> itemFaltas) async {
    setState(() => consultandoFaltas = !consultandoFaltas);
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListadoFaltas(
            faltas: itemFaltas,
            checkeds: checkeds,
          ),
        ));
    print(result);
    checkeds = result;
    String lasFaltas = '';
    int idx = 0;
    for (bool chk in checkeds) {
      if (chk) {
        lasFaltas += '${itemFaltas[idx]} ';
      }
      idx++;
    }
    setFaltasController.text = lasFaltas;
    setState(() => consultandoFaltas = !consultandoFaltas);
  }
}
