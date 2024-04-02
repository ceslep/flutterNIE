// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

class RegistrarInasistencia extends StatefulWidget {
  final String estudiante;
  final String asignacion;
  final String nombres;
  final String grado;
  final String nivel;
  final String numero;
  final String periodo;
  final String docente;
  final String asignatura;
  final String year;
  const RegistrarInasistencia(
      {super.key,
      required this.nombres,
      required this.grado,
      required this.docente,
      required this.asignatura,
      required this.estudiante,
      required this.asignacion,
      required this.nivel,
      required this.numero,
      required this.periodo,
      required this.year});

  @override
  State<RegistrarInasistencia> createState() => _RegistrarInasistenciaState();
}

class _RegistrarInasistenciaState extends State<RegistrarInasistencia> {
  bool guardando = false;
  late FToast fToast;
  String fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String horass = '';
  String horaClase = '';
  int detalleCount = 0;
  final TextEditingController _fechaController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController _detalleController = TextEditingController();
  List<String> horas = [
    'Cuantas horas faltó el estudiante',
    '1',
    '2',
    '3',
    '4',
    'Fuga',
    'Retardo'
  ];
  late final List<DropdownMenuItem> _horas;

  List<String> horasClase = [
    'Hora Clase',
    'Primera Hora',
    'Segunda Hora',
    'Tercera Hora',
    'Cuarta Hora',
    'Quinta Hora',
    'Sexta Hora',
    'Séptima Hora',
    'Octava Hora'
  ];
  late final List<DropdownMenuItem> _horasClase;

  @override
  void initState() {
    super.initState();
    _horas = horas
        .map((e) => DropdownMenuItem(
              value: !e.contains('Cuantas') ? e[0] : '',
              enabled: !e.contains('Cuantas') ? true : false,
              child: Text(e.contains('Cuantas') ||
                      e.contains('Fuga') ||
                      e.contains('Retardo')
                  ? e
                  : e[0]),
            ))
        .toList();
    _horasClase = horasClase
        .map((e) => DropdownMenuItem(
              value: e.contains('Clase') ? '' : e,
              enabled: !e.contains('Clase') ? true : false,
              child: Text(e),
            ))
        .toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      _fechaController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      fecha = _fechaController.text;
    }
  }

  Widget _buildDatePicker() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: _fechaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Fecha',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        foregroundColor: Colors.white,
        title: const Text('Inasistencia'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: !guardando
                ? IconButton(
                    onPressed: () async {
                      await guardarInasistencia(context);
                    },
                    icon: const Icon(Icons.save),
                  )
                : const SpinKitRipple(
                    size: 25,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                '${widget.nombres} ${widget.grado}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                widget.asignatura,
                style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: _buildDatePicker(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: horass != ''
                      ? const Text('Cuantas Horas faltó el estudiante')
                      : const SizedBox(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: DropdownButton(
                      value: horass,
                      items: _horas,
                      onChanged: (value) {
                        setState(() => horass = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: horaClase != ''
                      ? const Text('Hora Clase')
                      : const SizedBox(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: DropdownButton(
                      value: horaClase,
                      items: _horasClase,
                      onChanged: (value) {
                        setState(() => horaClase = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detalle',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onChanged: (value) {
                        detalleCount = value.length;
                        setState(() {});
                      },
                      maxLines: 3,
                      controller: _detalleController,
                      decoration: InputDecoration(
                          hoverColor: Colors.yellow,
                          border: const OutlineInputBorder(),
                          fillColor: Colors.yellow,
                          counter: Text(
                            '${detalleCount.toString()} de Mínimo  20 Caracteres',
                            style: TextStyle(
                                color: detalleCount >= 20
                                    ? Colors.blue
                                    : Colors.red,
                                fontSize: 10),
                          )),
                      autocorrect: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            iconColor: MaterialStatePropertyAll(Colors.black),
                            elevation: MaterialStatePropertyAll(Checkbox.width),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.indigoAccent),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async {
                          await guardarInasistencia(context);
                        },
                        child: SizedBox(
                          width: 0.6 * MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Registrar Inasistencia'),
                              !guardando
                                  ? const Icon(
                                      Icons.sick,
                                      size: 30,
                                      color: Color.fromARGB(255, 254, 204, 221),
                                    )
                                  : const SpinKitRipple(
                                      size: 25,
                                      color: Colors.white,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showToast() {
    fToast = FToast();
    fToast.init(context);
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
            "Inasistencia Registrada",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
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

  Future<void> guardarInasistencia(BuildContext context) async {
    setState(() => guardando = !guardando);
    String device = '';
    if (horass != "" && horaClase != "" && fecha != '') {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        device =
            '${androidInfo.manufacturer}  ${androidInfo.brand} ${androidInfo.hardware} android-${androidInfo.version.release} ${androidInfo.product} ${androidInfo.model} ';
      }
      final Uri url = Uri.parse('$urlbase/guardarInasistencia.php');
      final bodyData = json.encode({
        'estudiante': widget.estudiante,
        'docente': widget.docente,
        'asignacion': widget.asignacion,
        'detalle': _detalleController.text,
        'fecha': fecha,
        'excusa': '',
        'hora_clase': horaClase,
        'horas': horass,
        'materia': widget.asignatura,
        'nivel': widget.nivel,
        'numero': widget.numero,
        'periodo': widget.periodo,
        'device': device,
        'year': widget.year
      });
      var response = await http.post(url, body: bodyData);
      if (response.statusCode == 200) {
        await _showToast();
        fecha = '';
        horaClase = '';
        horass = '';
        detalleCount = 0;
        setState(() {});
        Navigator.of(context).pop();
      }
    } else {
      mostrarAlert(context, 'Inasistencias', 'Complete la información');
    }
    setState(() => guardando = !guardando);
  }
}
