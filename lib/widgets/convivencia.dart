// ignore_for_file: library_private_types_in_public_api

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

  @override
  Widget build(BuildContext context) {
    return listaConvivencia(context);
  }

  Widget listaConvivencia(BuildContext context) {
    return ListView.builder(
      itemCount: convivenciaPeriodo.length,
      itemBuilder: (context, index) {
        final convivencia = convivenciaPeriodo[index];
        return ListTile(
          title: Row(
            children: [
              Text(convivencia.tipoFalta),
              const SizedBox(width: 10),
              Text(convivencia.fecha),
            ],
          ),
          subtitle: Row(
            children: [Text(convivencia.hora), Text(convivencia.asignatura)],
          ),
        );
      },
    );
  }
}
