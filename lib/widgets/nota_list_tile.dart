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
  late List<ModeloNotas> notasDetallado;
  @override
  void initState() {
    super.initState();
    notasDetallado = widget.notas;
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
              Text('${widget.nota.valoracion} ',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              const Text('docente:  ',
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              Text('${widget.nota.nombresDocente} ',
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold))
            ],
          )
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotasDetalladas(detalleNotas: notasDetallado)));
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
