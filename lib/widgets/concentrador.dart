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
  final List<ModeloNotas> notasPeriodo;
  final List<String> periodos;
  final List<String> asignaturas;
  const Concentrador(
      {Key? key,
      required this.notasPeriodo,
      required this.periodos,
      required this.asignaturas})
      : super(key: key);

  @override
  State<Concentrador> createState() => _ConcentradorState();
}

class _ConcentradorState extends State<Concentrador> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 6 * widget.asignaturas.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
      itemBuilder: (context, index) {
        int idx = (index % 6);
        int ida = fila(index);
        /*String cell = "";
        if (dx == 0) cell = asignaturas[ida]; */
        return Text(widget.asignaturas[ida]);
      },
    );
  }
}
