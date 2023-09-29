// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';
import 'package:notas_ie/widgets/convivencia_detallado.dart';

class Convivencia extends StatefulWidget {
  final List<ModeloConvivencia> convivencia;
  const Convivencia({Key? key, required this.convivencia}) : super(key: key);

  @override
  _ConvivenciaState createState() => _ConvivenciaState();
}

class _ConvivenciaState extends State<Convivencia> {
  late final List<ModeloConvivencia> convivenciaPeriodo = widget.convivencia;
  late Map<String, dynamic> mapaModelo;
  @override
  Widget build(BuildContext context) {
    return listaConvivencia(context);
  }

  Widget listaConvivencia(BuildContext context) {
    return ListView(
        children: convivenciaPeriodo.map(
      (convivencia) {
        final String tipoFalta = convivencia.tipoFalta;
        final String fecha = convivencia.fecha;
        final String hora = convivencia.hora;
        final String asignatura = convivencia.asignatura;
        return ListTile(
          leading: SizedBox(
            height: double.infinity,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: getIcon(tipoFalta),
            ),
          ),
          title: Row(
            children: [
              const Text('Falta'),
              const SizedBox(width: 10),
              Text(tipoFalta,
                  style: TextStyle(
                      color: tipoFalta.contains('TIPO')
                          ? const Color.fromARGB(255, 207, 55, 55)
                          : const Color.fromARGB(255, 0, 127, 53),
                      fontWeight: FontWeight.bold))
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  const Text('Fecha:',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Text(fecha)
                ],
              ),
              Row(
                children: [
                  const Text('Hora:', style: TextStyle(color: Colors.cyan)),
                  const SizedBox(width: 10),
                  Text(hora)
                ],
              ),
              Row(
                children: [
                  const Text('Asignatura:',
                      style:
                          TextStyle(color: Color.fromARGB(255, 154, 2, 149))),
                  const SizedBox(width: 10),
                  Text(asignatura)
                ],
              ),
              const Divider()
            ],
          ),
          trailing: SizedBox(
            width: 100,
            height: 100,
            child: GestureDetector(
                child: const Icon(
                  Icons.arrow_circle_right_sharp,
                  color: Color.fromARGB(255, 9, 174, 0),
                  size: 38,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConvivenciaDetallado(
                                detalleConvivencia: convivencia,
                              )));
                }),
          ),
        );
      },
    ).toList());
  }

  Icon getIcon(String value) {
    const double tam = 50;
    switch (value) {
      case 'POSITIVO':
        return const Icon(Icons.sentiment_very_satisfied,
            color: Color.fromARGB(255, 21, 209, 36), size: tam);
      case 'TIPO I':
        return const Icon(Icons.sentiment_dissatisfied,
            color: Colors.amberAccent, size: tam);
      case 'TIPO II':
        return const Icon(Icons.sentiment_very_dissatisfied,
            color: Colors.redAccent, size: tam);
      default:
        return const Icon(Icons.abc);
    }
  }
}
