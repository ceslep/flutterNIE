import 'package:com_celesoft_notasieo/key_value.dart';
import 'package:com_celesoft_notasieo/widgets/aspectos_notas_docente.dart';
import 'package:com_celesoft_notasieo/widgets/notas_docente_individuales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotasDocente extends StatefulWidget {
  final List<Map<String, dynamic>> notas;
  final String asignatura;
  final String grado;
  final String docente;
  final String periodo;
  const NotasDocente({
    Key? key,
    required this.notas,
    required this.asignatura,
    required this.grado,
    required this.docente,
    required this.periodo,
  }) : super(key: key);

  @override
  State<NotasDocente> createState() => _NotasDocenteState();
}

class _NotasDocenteState extends State<NotasDocente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('${widget.asignatura} ${widget.grado}',
            style: const TextStyle(fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {"dataND": "home"});
            },
            child: const Icon(Icons.home, color: Colors.brown),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AspectosNotasDocente(
                      docente: widget.docente,
                      grado: widget.grado,
                      asignatura: widget.asignatura,
                      periodo: widget.periodo,
                    ),
                  ));
            },
            child: const Icon(Icons.note_alt_outlined, color: Colors.brown),
          ),
          TextButton(
            onPressed: () {},
            child: const Icon(Icons.notes_outlined, color: Colors.brown),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, {"dataND": "previous"}),
        ),
      ),
      body: ListView.builder(
          itemCount: widget.notas.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> nota = widget.notas[index];
            if (kDebugMode) {
              print(nota);
            }
            String nombres = nota['Nombres'];
            String valoracion = nota['Val'] ?? '';
            List<KeyValuePair> keyValuePairs = nota.entries
                .map((entry) => KeyValuePair(entry.key, entry.value))
                .toList();

// Access key-value pairs
            for (var pair in keyValuePairs) {
              if (kDebugMode) {
                print('Key: ${pair.key}, Value: ${pair.value}');
              }
            }
            double val = double.parse(valoracion != '' ? valoracion : '0');
            return Card(
              color: index % 2 == 0
                  ? Colors.lightGreen.shade100
                  : const Color.fromARGB(255, 209, 222, 194),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      nombres,
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 18.0),
                    Text(
                      valoracion,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: (val < 3) ? Colors.red : Colors.black),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Icon(Icons.apps),
                          onPressed: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotasDocenteIndividuales(
                                          keyValuePairs: keyValuePairs,
                                          docente: widget.docente,
                                          grado: widget.grado,
                                          asignatura: widget.asignatura,
                                          nombres: nombres),
                                ));
                            print(result["dataNDI"]);
                            if (result["dataNDI"] == "home") {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, {"dataND": "home"});
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.yellow),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: const Icon(Icons.sick),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: const Icon(Icons.accessibility),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
