// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:com_celesoft_notasieo/modelo_notas.dart';
import 'package:com_celesoft_notasieo/widgets/badge_text.dart';
import 'package:intl/intl.dart';

bool esDigito(String caracter) {
  return RegExp(r'^[0-9]$').hasMatch(caracter);
}

int? extraerUltimosDigitos(String cadena) {
  if (cadena.isEmpty) {
    // Maneja el caso de una cadena vacía o nula
    return 0; // O podrías lanzar una excepción o devolver un valor predeterminado según tus necesidades.
  }

  // Invierte la cadena para facilitar la extracción de los últimos dígitos
  String cadenaInvertida = cadena.split('').reversed.join();

  // Encuentra los dígitos en la cadena invertida
  String digitosEncontrados = '';
  for (int i = 0; i < cadenaInvertida.length; i++) {
    if (esDigito(cadenaInvertida[i])) {
      digitosEncontrados += cadenaInvertida[i];
    } else if (digitosEncontrados.isNotEmpty) {
      break; // Detén la búsqueda si ya has encontrado al menos un dígito
    }
  }

  // Invierte nuevamente los dígitos encontrados para obtener el orden correcto
  digitosEncontrados = digitosEncontrados.split('').reversed.join();

  // Convierte los dígitos a un entero
  int? resultado = int.tryParse(digitosEncontrados);

  return resultado;
}

class NotasDetalladas extends StatefulWidget {
  final List<ModeloNotas> detalleNotas;
  final String asignatura;
  const NotasDetalladas(
      {super.key, required this.detalleNotas, required this.asignatura});

  @override
  State<NotasDetalladas> createState() => _NotasDetalladasState();
}

class _NotasDetalladasState extends State<NotasDetalladas> {
  bool _isVisible = true;
  late List<ModeloNotas> notasDetalladas;
  late Map<String, dynamic> mapaModelo;
  List<Map<String, dynamic>> notas = [];
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      setState(() {
        _isVisible = !_isVisible; // Cambia la visibilidad del texto
        //  print({'v': _isVisible});
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notasDetalladas = widget.detalleNotas;
    notas.clear();
    mapaModelo = notasDetalladas[0].toMap();
    for (int i = 1; i <= 12; i++) {
      final String nota = mapaModelo['nota$i'];
      final String aspecto = mapaModelo['aspecto$i'];
      final String fecha = mapaModelo['fecha$i'];
      final String porcentaje = mapaModelo['porcentaje$i'];
      if (nota != "") {
        notas.add({
          'nota': nota,
          'aspecto': aspecto,
          'fecha': fecha,
          'porcentaje': porcentaje,
          'fechahora': mapaModelo['fechahora']
        });
      }
    }
    notas.sort(
      (a, b) => b['fecha'].compareTo(a['fecha']),
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent)),
        home: Scaffold(
            appBar: AppBar(
              title: Text(widget.asignatura),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: ListView(
              children: notas.map(
                (nota) {
                  final String aspecto = nota['aspecto'];
                  final String fecha = nota['fecha'];
                  final String porcentaje = nota['porcentaje'];
                  final double value = double.parse(nota['nota']);
                  final String subtitulo = nota['nota'];
                  final String subtitulo2 = ' Fecha: $fecha';
                  final String fechahora = nota['fechahora'];
                  DateTime now = DateTime.now();
                  DateTime date = DateFormat("yyyy-MM-dd").parse(fecha);
                  int diferencia = now.difference(date).inDays;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 2,
                      color: const Color.fromARGB(255, 246, 248, 242),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: SizedBox(
                            height: double.infinity,
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: getIcon(value),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                  child: Text(aspecto,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(width: 10),
                              BadgeText(
                                  text: '   ',
                                  badgeText: diferencia < 7 ? '.' : '',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 228, 55, 168)),
                                  color: Colors.blue),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('Nota: '),
                                  AnimatedOpacity(
                                    opacity: value < 3
                                        ? (_isVisible ? 1.0 : 0.0)
                                        : 1,
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      subtitulo,
                                      style: TextStyle(
                                          color: value < 3
                                              ? Colors.red
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(subtitulo2)
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Periodo: '),
                                  Text(mapaModelo['periodo'],
                                      style:
                                          const TextStyle(color: Colors.blue)),
                                  const SizedBox(width: 10),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Porcentaje: '),
                                  Text(porcentaje != ''
                                      ? porcentaje
                                      : 'Sin porcentaje declarado')
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Registrado:'),
                                  const SizedBox(width: 10),
                                  Text(fechahora,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                              /*  const Divider() */
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            )));
  }

  Icon getIcon(double value) {
    const double tam = 50;
    if (value >= 3 && value < 4) {
      return const Icon(Icons.filter_3, color: Colors.amber, size: tam);
    } else if (value >= 4 && value < 5) {
      return const Icon(Icons.filter_4, color: Colors.cyan, size: tam);
    } else if (value == 5) {
      return const Icon(Icons.filter_5, color: Colors.blueAccent, size: tam);
    } else if (value >= 2 && value < 3) {
      return const Icon(Icons.filter_2, color: Colors.red, size: tam);
    } else if (value >= 1 && value < 3) {
      return const Icon(Icons.filter_1, color: Colors.red, size: tam);
    } else {
      return const Icon(Icons.abc, color: Colors.black, size: tam);
    }
  }
}
