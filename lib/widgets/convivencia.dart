// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';
import 'package:notas_ie/widgets/convivencia_detallado.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../estudiante_provider.dart';
import '../convivencia_provider.dart';

class Convivencia extends StatefulWidget {
  final List<ModeloConvivencia> convivencia;

  const Convivencia({Key? key, required this.convivencia}) : super(key: key);

  @override
  _ConvivenciaState createState() => _ConvivenciaState();
}

class _ConvivenciaState extends State<Convivencia> {
  late List<ModeloConvivencia> convivenciaPeriodo = widget.convivencia;
  late Map<String, dynamic> mapaModelo;
  late EstudianteProvider estudianteProvider;
  late ConvivenciaProvider convivenciaProvider;
  List<ModeloConvivencia> listConvivencia = [];
  bool spin = false;
  Future<bool> iniciar() async {
    spin = true;
    estudianteProvider =
        Provider.of<EstudianteProvider>(context, listen: false);
    convivenciaProvider =
        Provider.of<ConvivenciaProvider>(context, listen: false);
    await convivenciaProvider.updateData(
        estudianteProvider.estudiante, (DateTime.now()).year.toString());
    listConvivencia = [];
    listConvivencia = convivenciaProvider.data;
    convivenciaPeriodo = listConvivencia;
    print({'convivencia': listConvivencia.length});
    setState(() {});
    spin = false;
    return false;
  }

  @override
  void initState() {
    super.initState();
    iniciar();
    spin = false;
  }

  @override
  void dispose() {
    spin = false;
    convivenciaPeriodo = [];
    listConvivencia = [];
    print({'liberando': 'si'});
    super.dispose();
  }

  Future<void> actualizar() async {
    await convivenciaProvider.updateData(
        estudianteProvider.estudiante, (DateTime.now()).year.toString());
    listConvivencia = convivenciaProvider.data;
    convivenciaPeriodo = listConvivencia;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    /* print({'spin1': spin});
    iniciar().then((value) {
      spin = false;
      print({'spin2': value});
      print({'totalccccc': listConvivencia.length});
      setState(() {});
    }); */
    return RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          await actualizar();
          setState(() {});
        },
        child: listaConvivencia(context));
  }

  Widget listaConvivencia(BuildContext context) {
    int i = convivenciaPeriodo.length + 1;
    DateTime now = DateTime.now();

    return convivenciaPeriodo.isNotEmpty
        ? ListView(
            children: convivenciaPeriodo.map(
            (convivencia) {
              i--;
              final String tipoFalta = convivencia.tipoFalta;
              final String fecha = convivencia.fecha;
              DateTime date = DateFormat("yyyy-MM-dd").parse(fecha);
              int diferencia = now.difference(date).inDays;
              print(diferencia);
              final String hora = convivencia.hora;
              final String asignatura = convivencia.asignatura;
              return ListTile(
                leading: SizedBox(
                  height: double.infinity,
                  width: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: getIcon(tipoFalta),
                  ),
                ),
                title: Row(
                  children: [
                    BadgeText(
                        text: i.toString(),
                        badgeText: diferencia < 7 ? '.' : ''),
                    const SizedBox(width: 10),
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
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Text(fecha)
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Hora:',
                            style: TextStyle(color: Colors.cyan)),
                        const SizedBox(width: 10),
                        Text(hora)
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Asignatura:',
                            style: TextStyle(
                                color: Color.fromARGB(255, 154, 2, 149))),
                        const SizedBox(width: 10),
                        Text(asignatura)
                      ],
                    ),
                    const Divider()
                  ],
                ),
                trailing: SizedBox(
                  width: 40,
                  height: 40,
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
          ).toList())
        : const Text('No hay registros');
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

class BadgeText extends StatefulWidget {
  final String text;
  final String badgeText;

  const BadgeText({super.key, required this.text, required this.badgeText});

  @override
  State<BadgeText> createState() => _BadgeTextState();
}

class _BadgeTextState extends State<BadgeText> {
  bool _isVisible = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      _isVisible = !_isVisible; // Cambia la visibilidad del texto
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Text('${widget.text}  ', style: const TextStyle(fontSize: 26)),
        if (widget.badgeText.isNotEmpty)
          Positioned(
              width: 15,
              height: 15,
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity:
                    widget.badgeText.isNotEmpty ? (_isVisible ? 1.0 : 0.0) : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 10),
                ),
              )),
      ],
    );
  }
}
