import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_notas.dart';
import 'package:notas_ie/widgets/custom_alert.dart';
import 'package:notas_ie/widgets/notas_detalladas.dart';

class NotaListTile extends StatefulWidget {
  final ModeloNotas nota;
  final List<ModeloNotas> notas;

  const NotaListTile({Key? key, required this.nota, required this.notas})
      : super(key: key);

  @override
  State<NotaListTile> createState() => _NotaListTileState();
}

class _NotaListTileState extends State<NotaListTile> {
  bool _isVisible = true;
  late Timer _timer;
  late List<ModeloNotas> notasDetallado = widget.notas;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isVisible = !_isVisible; // Cambia la visibilidad del texto
        print({'v': _isVisible});
      });
    });
//    notasDetallado = widget.notas;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.nota.asignatura,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green)),
      subtitle: Column(
        children: [
          Row(
            children: [
              const Text('Valoración: '),
              AnimatedOpacity(
                opacity: double.parse(widget.nota.valoracion) < 3
                    ? (_isVisible ? 1.0 : 0.0)
                    : 1,
                duration: const Duration(milliseconds: 200),
                child: Text('${widget.nota.valoracion} ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.nota.valoracion != ""
                            ? double.parse(widget.nota.valoracion) < 3
                                ? Colors.red
                                : Colors.black
                            : Colors.black)),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Docente',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text('${widget.nota.nombresDocente} ',
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold)),
                ],
              )
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
              Icons.arrow_circle_right,
              color: Colors.blueGrey,
              size: 38,
            ),
            onTap: () {
              notasDetallado = widget.notas;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotasDetalladas(
                            detalleNotas: notasDetallado,
                            asignatura: widget.nota.asignatura,
                          )));
            }),
      ),
    );
  }

  void mostrarAlert(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          key: const Key('alert'),
          title: title,
          content: text,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
