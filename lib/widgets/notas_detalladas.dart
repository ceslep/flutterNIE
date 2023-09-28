// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_notas.dart';

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
      {Key? key, required this.detalleNotas, required this.asignatura})
      : super(key: key);

  @override
  State<NotasDetalladas> createState() => _NotasDetalladasState();
}

class _NotasDetalladasState extends State<NotasDetalladas> {
  bool _isVisible = true;
  late List<ModeloNotas> notasDetalladas;
  late Map<String, dynamic> mapaModelo;
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

    mapaModelo = notasDetalladas[0].toMap();
    /*  mapaModelo.forEach((clave, valor) {
      print('Clave: $clave, Valor: $valor');
    }); */
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
              children: mapaModelo.keys
                  .where((key) =>
                      mapaModelo[key] != '' &&
                      key.contains('nota') &&
                      mapaModelo['nota'] != '')
                  .map(
                (clave) {
                  final numero = extraerUltimosDigitos(clave);
                  late final String claveA;
                  late final String claveN;
                  late final String fechaN;
                  late final String porcentajeN;
                  late final String titulo;
                  late final String subtitulo;
                  late final String subtitulo2;
                  late final double valuen;
                  if (esDigito(numero.toString())) {
                    claveA = 'aspecto$numero';
                    claveN = 'nota$numero';
                    fechaN = 'fecha$numero';
                    porcentajeN = 'porcentaje$numero';
                    titulo = mapaModelo[claveA] != ''
                        ? mapaModelo[claveA]
                        : 'No hay aspecto registrado';
                    subtitulo = mapaModelo[claveN];
                    valuen = double.parse(subtitulo);
                    subtitulo2 = ' Fecha: ${mapaModelo[fechaN]}';
                    print(claveA);
                  } else {
                    titulo = '';
                    subtitulo = '';
                    subtitulo2 = '';
                    valuen = 0;
                  }
                  return titulo != ''
                      ? ListTile(
                          leading: SizedBox(
                            height: double.infinity,
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: getIcon(valuen),
                            ),
                          ),
                          title: Text(mapaModelo[claveA],
                              style: const TextStyle(color: Colors.green)),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('Nota: '),
                                  AnimatedOpacity(
                                    opacity: valuen < 3
                                        ? (_isVisible ? 1.0 : 0.0)
                                        : 1,
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      subtitulo,
                                      style: TextStyle(
                                          color: valuen < 3
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
                                  Text(mapaModelo[porcentajeN] != ''
                                      ? mapaModelo[porcentajeN]
                                      : 'Sin porcentaje declarado')
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Registrado:'),
                                  const SizedBox(width: 10),
                                  Text(mapaModelo['fechahora'],
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                              const Divider()
                            ],
                          ),
                        )
                      : const Text('');
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
