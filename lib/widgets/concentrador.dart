// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:com_celesoft_notasieo/modelo_notas.dart';

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
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Concentrador'),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          asignatura = widget.asignaturas[index];
          TextStyle styleHeader = const TextStyle(fontWeight: FontWeight.bold);
          List<ModeloNotas> notas = widget.notasPeriodos
              .where((nota) => nota.asignatura == asignatura)
              .toList();
          return ListTile(
            title: Column(
              children: [
                index == 0
                    ? Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.5), // Color y opacidad de la sombra
                                    spreadRadius:
                                        5, // Radio de propagación de la sombra
                                    blurRadius:
                                        7, // Radio de desenfoque de la sombra
                                    offset: const Offset(0,
                                        3), // Desplazamiento de la sombra en x y y
                                  ),
                                ],
                                color: Colors.green),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 120,
                                    child: Text(
                                      'Asignatura',
                                      style: styleHeader,
                                    )),
                                SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'P1',
                                      style: styleHeader,
                                    ))),
                                SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'P2',
                                      style: styleHeader,
                                    ))),
                                SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'P3',
                                      style: styleHeader,
                                    ))),
                                SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'P4',
                                      style: styleHeader,
                                    ))),
                                SizedBox(
                                    width: 50,
                                    child: Center(
                                        child: Text(
                                      'Def',
                                      style: styleHeader,
                                    ))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                Row(
                  children: [
                    SizedBox(
                        width: 120, child: Text(widget.asignaturas[index])),
                    Row(
                      children: notas.map((nota) {
                        double value = double.parse(nota.valoracion);
                        TextStyle style = value < 3
                            ? const TextStyle(color: Colors.red)
                            : const TextStyle(color: Colors.blue);
                        return SizedBox(
                            width: 50,
                            child: Center(
                                child: Text(nota.valoracion, style: style)));
                      }).toList(),
                    )
                    //  notas.map((nota) => Text(nota.valoracion))
                  ],
                ),
                const Divider()
              ],
            ),
          );
        }, childCount: widget.asignaturas.length))
      ],
    );
  }
}
