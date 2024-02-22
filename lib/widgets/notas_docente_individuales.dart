import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/widgets/custom_alert.dart';
import 'package:flutter/material.dart';

class NotasDocenteIndividuales extends StatefulWidget {
  final List<KeyValuePair> keyValuePairs;
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
      required this.nombres})
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

  void showNumberDialog(
      BuildContext context, String title, String value, int indice) {
    final TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            keyboardType: TextInputType.number, // Tipo de teclado numérico
            controller: controller,
          ),
          actions: [
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
      if ((value != null) && (value != "") && (value != " ")) {
        double val = double.parse(value);
        if ((val > 5) || (val < 1)) {
          mostrarAlert(context, 'Error en la nota', 'Valor no permitido');
        } else {
          // Procesar el valor ingresado
          widget.keyValuePairs[indice].value = value;
        }
      } else {
        mostrarAlert(context, 'Error en el valor', 'No puede estar en blanco');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    inicio();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 221, 255, 182))),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.nombres, style: const TextStyle(fontSize: 12)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
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
              return Card(
                  child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: Text('Nota $numero'),
                subtitle: Row(
                  children: [
                    Text(widget.keyValuePairs[indiceAnotacion].value ?? '',
                        style: const TextStyle(color: Colors.green)),
                    Text(widget.keyValuePairs[indiceNota].value ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(flex: 1), // Add Spacer to fill remaining space
                    SizedBox(
                      height: 40,
                      width: 55,
                      child: ElevatedButton(
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
                              widget.keyValuePairs[indiceNota].value ?? '',
                              indiceNota);
                        },
                        child: const Icon(Icons.edit_note_outlined, size: 30),
                      ),
                    ),
                  ],
                ),
              ));
            },
          ),
        ));
  }
}
