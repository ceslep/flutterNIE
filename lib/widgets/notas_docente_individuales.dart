import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/modelo_notas_full.dart';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:flutter/material.dart';

class NotasDocenteIndividuales extends StatefulWidget {
  final List<KeyValuePair> keyValuePairs;
  final List<ModeloNotasFull> notasFullModelo;
  final String docente;
  final String grado;
  final String asignatura;
  final String nombres;

  const NotasDocenteIndividuales(
      {Key? key,
      required this.keyValuePairs,
      required this.docente,
      required this.grado,
      required this.asignatura,
      required this.nombres,
      required this.notasFullModelo})
      : super(key: key);

  @override
  State<NotasDocenteIndividuales> createState() =>
      _NotasDocenteIndividualesState();
}

class _NotasDocenteIndividualesState extends State<NotasDocenteIndividuales> {
  List<KeyValuePair> anotas = [];
  @override
  void initState() {
    super.initState();
    inicio();
  }

  void inicio() {
    anotas = widget.keyValuePairs
        .where(
          (element) =>
              element.key.contains("N") && !element.key.contains("Nombres"),
        )
        .toList();
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

  void showNumberDialog(BuildContext context, String title, String subtitle,
      String value, int indice) {
    final TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(title),
              Text(subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.blue))
            ],
          ),
          content: TextField(
            keyboardType: TextInputType.number, // Tipo de teclado numérico
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, "-1");
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    ).then((value) {
      if ((value != null) &&
          (value != "") &&
          (value != " ") &&
          (value != "-1")) {
        double val = double.parse(value);
        if ((val > 5) || (val < 1)) {
          mostrarAlert(context, 'Error en la nota', 'Valor no permitido');
        } else {
          // Procesar el valor ingresado
          widget.keyValuePairs[indice].value = value;
        }
      } else {
        if (value != "-1") {
          mostrarAlert(
              context, 'Error en el valor', 'No puede estar en blanco');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    inicio();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        foregroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.nombres, style: const TextStyle(fontSize: 12)),
            Text('${widget.asignatura} ${widget.grado}',
                style: const TextStyle(fontSize: 12, color: Colors.white))
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, {"dataNDI": "previous"}),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {"dataNDI": "home"});
            },
            child: const Icon(Icons.home, color: Colors.white),
          ),
          TextButton(
            onPressed: () {},
            child: const Icon(Icons.save, color: Colors.black87),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: anotas.length,
        itemBuilder: (context, index) {
          KeyValuePair data = anotas[index];
          String str = data.key;

          int indiceNumero = str.indexOf(RegExp(r'\d'));
          String numeroStr = str.substring(indiceNumero);

          int numero = int.parse(numeroStr);

          int indiceNota = widget.keyValuePairs
              .indexWhere((element) => element.key == 'N$numero');
          int indiceAnotacion = widget.keyValuePairs
              .indexWhere((element) => element.key == 'aspecto$numero');
          int indiceFechaNota = widget.keyValuePairs
              .indexWhere((element) => element.key == 'fecha$numero');
          String fechaNota = widget.keyValuePairs[indiceFechaNota].value ?? '';
          String strNota = widget.keyValuePairs[indiceNota].value.trim();
          double laNota = double.parse(strNota != "" ? strNota : "0");
          int indiceEstudiante = widget.keyValuePairs
              .indexWhere((element) => element.key == 'estudiante');
          String estudiante = widget.keyValuePairs[indiceEstudiante].value;
          int indiceEstudianteNFM = widget.notasFullModelo
              .indexWhere((element) => element.estudiante == estudiante);
          ModeloNotasFull modelNota =
              widget.notasFullModelo[indiceEstudianteNFM];
          modelNota.nota1=    
          return Card(
              child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              'Nota $numero',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 0.65 * MediaQuery.of(context).size.width,
                      child: Text(
                          widget.keyValuePairs[indiceAnotacion].value ?? '',
                          style: const TextStyle(color: Colors.green)),
                    ),
                    const SizedBox(
                        width: 27), // Add Spacer to fill remaining space
                    SizedBox(
                      height: 40,
                      width: 55,
                      child: TextButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.amberAccent),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.black)),
                        onPressed: () {
                          // Handle button press
                          showNumberDialog(
                              context,
                              'Nota $numero',
                              widget.keyValuePairs[indiceAnotacion].value ?? '',
                              widget.keyValuePairs[indiceNota].value ?? '',
                              indiceNota);
                        },
                        child: Text(laNota != 0 ? laNota.toString() : '',
                            style: TextStyle(
                                color: laNota < 3 ? Colors.red : Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('Fecha: $fechaNota')],
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}
