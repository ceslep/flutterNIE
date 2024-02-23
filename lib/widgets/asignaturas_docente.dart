import 'package:com_celesoft_notasieo/widgets/notas_docente.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AsignaturasDocente extends StatefulWidget {
  final List<String> asignaturas;
  final String grado;
  final String nivel;
  final String numero;
  final String docente;
  final String nombresDocente;
  final String asignacion;
  final String periodo;
  const AsignaturasDocente(
      {Key? key,
      required this.asignaturas,
      required this.docente,
      required this.grado,
      required this.nivel,
      required this.numero,
      required this.nombresDocente,
      required this.asignacion,
      required this.periodo})
      : super(key: key);

  @override
  State<AsignaturasDocente> createState() => _AsignaturasDocenteState();
}

class _AsignaturasDocenteState extends State<AsignaturasDocente> {
  List<Map<String, dynamic>> notas = [];
  bool consultando = false;
  String aasignatura = "";
  Future<List<Map<String, dynamic>>> getNotas(String asignatura) async {
    consultando = true;
    aasignatura = asignatura;
    setState(() {});
    const String urlbase = 'https://app.iedeoccidente.com';

    final url = Uri.parse('$urlbase/getNotas.php');
    final bodyData = json.encode({
      'docente': widget.docente,
      'asignacion': widget.asignacion,
      'nivel': widget.nivel,
      'numero': widget.numero,
      'asignatura': asignatura,
      'periodo': widget.periodo
    });

    final response = await http.post(url, body: bodyData);
    consultando = false;
    aasignatura = "";
    setState(() {});
    if (response.statusCode == 200) {
      notas = jsonDecode(response.body).cast<Map<String, dynamic>>();
      notas.sort(
        (a, b) => a['Nombres'].compareTo(b['Nombres']),
      );
      return notas;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent)),
        home: Scaffold(
            appBar: AppBar(
              title: Text(widget.nombresDocente,
                  style: const TextStyle(fontSize: 14)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: ListView.builder(
                itemCount: widget.asignaturas.length,
                itemBuilder: (context, index) {
                  String asignatura = widget.asignaturas[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.asignaturas[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {
                              getNotas(asignatura).then((value) {
                                notas = value;
                                if (kDebugMode) {
                                  print(notas);
                                }
                                if (notas.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotasDocente(
                                          notas: notas,
                                          asignatura: asignatura,
                                          grado: widget.grado,
                                          docente: widget.docente,
                                          periodo: widget.periodo,
                                        ),
                                      ));
                                }
                              });

                              if (kDebugMode) {
                                print({"notas": notas});
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(widget.grado),
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(''),
                                ),

                                consultando &&
                                        aasignatura == widget.asignaturas[index]
                                    ? const SpinKitChasingDots(
                                        color: Colors
                                            .yellow, // Color de la animación
                                        size: 15.0,
                                      )
                                    : const Icon(Icons.cloud_download), // )
                              ],
                            ))
                      ],
                    ),
                    subtitle: const Divider(),
                  );
                })));
  }
}
