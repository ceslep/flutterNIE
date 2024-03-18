import 'package:com_celesoft_notasieo/widgets/asignaturas_docente.dart';
import 'package:com_celesoft_notasieo/widgets/error_internet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

class EntradaDocentes extends StatefulWidget {
  final String docente;
  final String nombresDocente;
  final String asignacionDocente;
  final String periodo;
  final String year;
  const EntradaDocentes(
      {super.key,
      required this.docente,
      required this.nombresDocente,
      required this.asignacionDocente,
      required this.periodo,
      required this.year});

  @override
  State<EntradaDocentes> createState() => _EntradaDocentesState();
}

class _EntradaDocentesState extends State<EntradaDocentes> {
  List<Map<String, dynamic>> jsonData = [];
  bool cargado = false;
  Future<List<Map<String, dynamic>>> obtenerDatos() async {
    if (kDebugMode) {
      print({"docente": widget.docente});
    }
    final url = Uri.parse('$urlbase/generarMenu.php');
    final bodyData = json.encode({'docente': widget.docente});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<Map<String, dynamic>>();
    } else {
      // ignore: use_build_context_synchronously
      String result = await errorInternet(
          context,
          "Error ${response.statusCode}",
          "Se ha presentado un error de Intertet");
      if (result == "volver") {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    cargado = false;
    obtenerDatos().then((datos) {
      jsonData = datos;
      if (kDebugMode) {
        print({"data": jsonData});
      }
      cargado = true;
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.nombresDocente,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(6),
        child: !cargado
            ? const Center(
                child: SpinKitCubeGrid(
                  color: Colors.blue,
                  size: 40,
                ),
              )
            : ListView.builder(
                itemCount: jsonData.length,
                itemBuilder: (context, index) {
                  String grado = jsonData[index]['grado'];
                  List<dynamic> asignaturas = jsonData[index]['asignaturas'];
                  List<String> aasignaturas = [];
                  aasignaturas = asignaturas
                      .map((e) => e['asignatura'].toString())
                      .toList();
                  String nivel = jsonData[index]['nivel'];
                  String numero = jsonData[index]['numero'];
                  if (kDebugMode) {
                    print(aasignaturas);
                  }
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Grado: $grado',
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(flex: 2),
                        SizedBox(
                          width: 45,
                          height: 45,
                          child: GestureDetector(
                            child: const Icon(Icons.arrow_circle_right,
                                size: 50, color: Colors.amber),
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AsignaturasDocente(
                                      asignaturas: aasignaturas,
                                      grado: grado,
                                      nivel: nivel,
                                      numero: numero,
                                      docente: widget.docente,
                                      nombresDocente: widget.nombresDocente,
                                      asignacion: widget.asignacionDocente,
                                      periodo: widget.periodo,
                                      year: widget.year),
                                ),
                              );
                              if (kDebugMode) {
                                print({"resulti": result});
                              }
                              // ignore: use_build_context_synchronously
                              /* ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No hay nada para retroceder.'),
                                ),
                              ); */
                            },
                          ),
                        )
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Asignaturas ${aasignaturas.length.toString()}'),
                        const Divider()
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
