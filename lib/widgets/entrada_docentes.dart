import 'package:com_celesoft_notasieo/widgets/asignaturas_docente.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

class EntradaDocentes extends StatefulWidget {
  final String docente;
  const EntradaDocentes({Key? key, required this.docente}) : super(key: key);

  @override
  State<EntradaDocentes> createState() => _EntradaDocentesState();
}

class _EntradaDocentesState extends State<EntradaDocentes> {
  List<Map<String, dynamic>> jsonData = [];

  Future<List<Map<String, dynamic>>> obtenerDatos() async {
    if (kDebugMode) {
      print({"docente": widget.docente});
    }
    final url = Uri.parse('$urlbase/generarMenu.php');
    final bodyData = json.encode({'docente': widget.docente});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<Map<String, dynamic>>();
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    obtenerDatos().then((datos) {
      jsonData = datos;
      if (kDebugMode) {
        print({"data": jsonData});
      }
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Docente'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(6),
            child: ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                String grado = jsonData[index]['grado'];
                List<dynamic> asignaturas = jsonData[index]['asignaturas'];
                List<String> aasignaturas = [];
                aasignaturas =
                    asignaturas.map((e) => e['asignatura'].toString()).toList();

                if (kDebugMode) {
                  print(aasignaturas);
                }
                return ListTile(
                  title: Row(
                    children: [
                      Text('Grado: $grado'),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      child: const Icon(
                        Icons.arrow_circle_right,
                        color: Colors.amberAccent,
                        size: 38,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AsignaturasDocente(
                                  asignaturas: aasignaturas,
                                  docente: widget.docente),
                            ));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
