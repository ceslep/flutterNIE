// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_notas.dart';

int fila(int numero) {
  if (numero >= 0 && numero <= 5) {
    return 0;
  } else if (numero >= 6 && numero <= 11) {
    return 1;
  } else if (numero >= 12 && numero <= 17) {
    return 2;
  } else if (numero >= 18 && numero <= 23) {
    return 3;
  } else if (numero >= 24 && numero <= 29) {
    return 4;
  } else if (numero >= 30 && numero <= 35) {
    return 5;
  } else if (numero >= 36 && numero <= 41) {
    return 6;
  } else if (numero >= 42 && numero <= 47) {
    return 7;
  } else if (numero >= 48 && numero <= 53) {
    return 8;
  } else if (numero >= 54 && numero <= 59) {
    return 9;
  } else if (numero >= 60 && numero <= 65) {
    return 10;
  } else if (numero >= 66 && numero <= 71) {
    return 11;
  } else if (numero >= 72 && numero <= 77) {
    return 12;
  } else if (numero >= 78 && numero <= 83) {
    return 13;
  } else if (numero >= 84 && numero <= 89) {
    return 14;
  } else if (numero >= 90 && numero <= 95) {
    return 15;
  } else if (numero >= 96 && numero <= 101) {
    return 16;
  } else if (numero >= 102 && numero <= 107) {
    return 17;
  } else if (numero >= 108 && numero <= 113) {
    return 18;
  } else {
    return 19; // Valor por defecto para rangos no especificados
  }
}

class Concentrador extends StatefulWidget {
  final List<ModeloNotas> notasPeriodos;
  final List<String> periodos;
  final List<String> asignaturas;

  const Concentrador(
      {Key? key,
      required this.notasPeriodos,
      required this.periodos,
      required this.asignaturas})
      : super(key: key);

  @override
  State<Concentrador> createState() => _ConcentradorState();
}

class _ConcentradorState extends State<Concentrador> {
  String asignatura = "";
  String periodo = "";
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(children: <Widget>[
          TableCell(
              child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.green,
            width: 100.0, // Ancho personalizado para la celda 3
            child: const Center(
              child: Text('Asignatura'),
            ),
          )),
          const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(child: Text('P1'))),
          const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(child: Text('P2'))),
          const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(child: Text('P3'))),
          const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(child: Text('P4'))),
          const TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Center(child: Text('Def'))),
        ])
      ],
    );
  }
}
