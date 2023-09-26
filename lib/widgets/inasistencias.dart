import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_inasistencias.dart';
import 'package:notas_ie/widgets/entrada_app.dart';

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
  late final List<ModeloInasistencias> inasistenciasPeriodo = widget
      .inasistencias
      .where((inasistencia) => inasistencia.periodo == widget.periodoActual)
      .toList();
  @override
  void initState() {
    super.initState();
    print({'inaslength': inasistenciasPeriodo.length});
  }

  @override
  Widget build(BuildContext context) {
    return inasistenciasPeriodo.isNotEmpty
        ? listaInasistencias(context)
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

  Widget listaInasistencias(BuildContext context) {
    return ListView.builder(
      itemCount: inasistenciasPeriodo.length,
      itemBuilder: (context, index) {
        final inasistencia = inasistenciasPeriodo[index];
        return ListTile(
          title: Text(inasistencia.materia,
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
