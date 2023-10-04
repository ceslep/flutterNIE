// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:notas_ie/estudiante_provider.dart';
import 'package:notas_ie/inasistencias_provider.dart';
import 'package:notas_ie/modelo_inasistencias.dart';
import 'package:notas_ie/widgets/badge_text.dart';
import 'package:notas_ie/widgets/entrada_app.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Inasistencias extends StatefulWidget {
  final List<ModeloInasistencias> inasistencias;
  final String periodoActual;
  const Inasistencias(
      {Key? key, required this.inasistencias, required this.periodoActual})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  State<Inasistencias> createState() => _InasistenciasState();
}

class _InasistenciasState extends State<Inasistencias> {
  late EstudianteProvider estudianteProvider;
  late InasistenciasProvider inasistenciasProvider;
  List<ModeloInasistencias> inasistenciasPeriodo = [];
  bool spin = false;
  Future<bool> iniciar() async {
    spin = true;
    estudianteProvider =
        Provider.of<EstudianteProvider>(context, listen: false);
    inasistenciasProvider =
        Provider.of<InasistenciasProvider>(context, listen: false);
    await inasistenciasProvider.updateData(
        estudianteProvider.estudiante, (DateTime.now()).year.toString());
    inasistenciasPeriodo = inasistenciasProvider.data;
    if (mounted) {
      super.setState(
        () {},
      );
    }

    /* inasistenciasPeriodo = inasistenciasPeriodo
        .where((inasistencia) => inasistencia.periodo == widget.periodoActual)
        .toList(); */
    spin = false;
    return false;
    /* print({'convivencia': listConvivencia.length}); */
  }

  @override
  void initState() {
    super.initState();
    iniciar();
    print({'inaslength': inasistenciasPeriodo.length});
    spin = false;
  }

  @override
  void dispose() {
    spin = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*  iniciar().then((value) {
      spin = value;
      print({'spin2': value});
    }); */
    return inasistenciasPeriodo.isNotEmpty
        ? ListaInasistencias(
            inasistenciasPeriodo: inasistenciasPeriodo, context: context)
        : spin
            ? const SpinKitCircle(
                color: Colors.blue, // Color de la animación
                size: 40.0,
              )
            : Center(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    height: 120,
                    width: 300,
                    child: Column(
                      children: [
                        const Text('No hay inasistencias para'),
                        Text('el período ${widget.periodoActual}'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntradaApp(
                                          elPeriodo: widget.periodoActual,
                                        )),
                              );
                            },
                            child: const Text('Volver'))
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget resumenInasistencias(BuildContext context) {
    return const Text('Hola');
  }
}

class ListaInasistencias extends StatelessWidget {
  const ListaInasistencias({
    super.key,
    required this.inasistenciasPeriodo,
    required this.context,
  });

  final List<ModeloInasistencias> inasistenciasPeriodo;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: inasistenciasPeriodo.length,
      itemBuilder: (context, index) {
        final inasistencia = inasistenciasPeriodo[index];
        DateTime now = DateTime.now();
        DateTime date = DateFormat("yyyy-MM-dd").parse(inasistencia.fecha);
        int diferencia = now.difference(date).inDays;
        return ListTile(
          title: BadgeText(
              text: inasistencia.materia,
              badgeText: diferencia < 7 ? '.' : '',
              style: const TextStyle(fontWeight: FontWeight.bold),
              color: Colors.greenAccent),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text('Fecha: ${inasistencia.fecha}'),
                  const SizedBox(width: 10),
                  const Text('Horas:'),
                  const SizedBox(width: 10),
                  Text(inasistencia.horas,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))
                ],
              ),
              Row(
                children: [
                  Text(
                    inasistencia.detalle != ''
                        ? inasistencia.detalle
                        : 'Sin detalle',
                    style: TextStyle(color: Colors.green.shade300),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Row(
                children: [
                  const Text('Hora Clase:'),
                  const SizedBox(width: 10),
                  Text(
                    inasistencia.horaClase,
                    style: const TextStyle(color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Excusa:'),
                  const SizedBox(width: 10),
                  Text(inasistencia.excusa != ''
                      ? inasistencia.excusa
                      : 'Sin excusa')
                ],
              ),
              Row(
                children: [
                  const Text('Período: '),
                  Text(inasistencia.periodo,
                      style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold))
                ],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
