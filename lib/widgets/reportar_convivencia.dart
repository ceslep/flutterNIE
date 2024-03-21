// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:com_celesoft_notasieo/widgets/listado_faltas.dart';
import 'package:flutter/material.dart';
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

  List<Map<String, dynamic>> _itemsFaltas = [];

  Future<List<Map<String, dynamic>>> getFaltas(String tipo) async {
    final url = Uri.parse('$urlbase/getItemsConvivencia.php');

    var response = await http.post(url, body: json.encode({'tipo': tipo}));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convivencia'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.yellowAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: DropdownButton(
              items: _itemsTipos,
              onChanged: (value) async {
                _itemsFaltas = await getFaltas(value);
                var result = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListadoFaltas(
                        faltas: _itemsFaltas
                            .map((e) => e['itemConvivencia'].toString())
                            .toList(),
                      ),
                    ));
              },
              hint: const Text('Seleccione el tipo de falta'),
            ),
          ),
        ],
      ),
    );
  }
}
