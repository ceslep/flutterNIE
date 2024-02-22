import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotasDocente extends StatefulWidget {
  final List<Map<String, dynamic>> notas;
  final String asignatura;
  final String grado;
  const NotasDocente(
      {Key? key,
      required this.notas,
      required this.asignatura,
      required this.grado})
      : super(key: key);

  @override
  State<NotasDocente> createState() => _NotasDocenteState();
}

class _NotasDocenteState extends State<NotasDocente> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 221, 255, 182))),
        home: Scaffold(
            appBar: AppBar(
              title: Text('${widget.asignatura} ${widget.grado}'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
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
                  double val =
                      double.parse(valoracion != '' ? valoracion : '0');
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
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
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
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: const Text('Notas'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellow),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                child: const Text('Inasistencia'),
                                onPressed: () {},
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: const Text('Convivencia'),
                                onPressed: () {},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })));
  }
}
