// ignore_for_file: library_private_types_in_public_api

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';

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
        print({convivencia.toMap()});
        final String tipoFalta = convivencia.tipoFalta;
        final String fecha = convivencia.fecha;
        final String hora = convivencia.hora;
        return ListTile(
          leading: SizedBox(
            height: double.infinity,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: getIcon(tipoFalta),
            ),
          ),
          title: Row(
            children: [
              const Text('Falta'),
              const SizedBox(width: 10),
              Text(convivencia.tipoFalta)
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  const Text('Fecha'),
                  const SizedBox(width: 10),
                  Text(fecha)
                ],
              ),
              Row(
                children: [
                  const Text('Hora'),
                  const SizedBox(width: 10),
                  Text(hora)
                ],
              )
            ],
          ),
        );
      },
    ).toList());
  }

  Icon getIcon(String value) {
    const double tam = 50;
    switch (value) {
      case 'TIPO I':
        return const Icon(Icons.access_alarm,
            color: Colors.amberAccent, size: tam);
      case 'TIPO II':
        return const Icon(Icons.dangerous, color: Colors.redAccent, size: tam);
      default:
        return const Icon(Icons.abc);
    }
  }
}
