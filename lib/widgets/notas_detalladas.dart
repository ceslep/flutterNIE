// ignore_for_file: avoid_print

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
  late List<ModeloNotas> notasDetalladas;
  late Map<String, dynamic> mapaModelo;
  @override
  void initState() {
    super.initState();
    notasDetalladas = widget.detalleNotas;

    mapaModelo = notasDetalladas[0].toMap();
    mapaModelo.forEach((clave, valor) {
      print('Clave: $clave, Valor: $valor');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  .where((key) => mapaModelo[key] != '' && key.contains('nota'))
                  .map(
                (clave) {
                  final numero = extraerUltimosDigitos(clave);
                  late final String claveA;
                  late final String claveN;
                  late final String fechaN;
                  late final String titulo;
                  late final String subtitulo;
                  late final String subtitulo2;
                  late final double valuen;
                  if (esDigito(numero.toString())) {
                    claveA = 'aspecto$numero';
                    claveN = 'nota$numero';
                    fechaN = 'fecha$numero';
                    titulo = mapaModelo[claveA];
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
                  return ListTile(
                    title: Text(titulo),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Nota: '),
                            Text(
                              subtitulo,
                              style: TextStyle(
                                  color:
                                      valuen < 3 ? Colors.red : Colors.black),
                            ),
                            Text(subtitulo2)
                          ],
                        ),
                        const Divider()
                      ],
                    ),
                  );
                },
              ).toList(),
            )));
  }
}
