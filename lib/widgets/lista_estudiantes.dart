// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:com_celesoft_notasieo/total_estudiantes_provider.dart';

import '../modelo_Estudiantes.dart';

class ListaEstudiantes extends StatefulWidget {
  const ListaEstudiantes({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantes> createState() => _ListaEstudiantesState();
}

class _ListaEstudiantesState extends State<ListaEstudiantes> {
  List<Estudiantes> listado = [];
  List<Estudiantes> listadoFiltrado = [];
  final TextEditingController _searchController = TextEditingController();

  Future<List<Estudiantes>> cargarDatos() async {
    final listaestudiantesProvider =
        Provider.of<TotalEstudiantesProvider>(context, listen: false);
    await listaestudiantesProvider.updateData();
    print({'r=>': listaestudiantesProvider.data.length});
    return listaestudiantesProvider.data;
  }

  void filterListado(String text) {
    if (text.length >= 4) {
      listadoFiltrado = listado.where((estudiante) {
        print(estudiante);
        if (estudiante.nombres.contains(text) ||
            estudiante.estudiante.contains(text) ||
            estudiante.sede.contains(text)) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } else {
      listadoFiltrado = listado;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cargarDatos().then((value) {
      listado = value;
      listadoFiltrado = listado;
      filterListado('');
      setState(() {});
    });

    _searchController.addListener(() {
      final text = _searchController.text.toUpperCase();
      filterListado(text);
      print('----->');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent)),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Lista de Estudiantes'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.lightBlueAccent,
            ),
            body: listadoFiltrado.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Buscar",
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                // _searchController.
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: listadoFiltrado.map(
                            (estudiante) {
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(context, estudiante);
                                },
                                title: Text(estudiante.nombres,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Identificacion:'),
                                        const SizedBox(width: 10),
                                        Text(estudiante.estudiante,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontStyle: FontStyle.italic)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Grupo:'),
                                        const SizedBox(width: 10),
                                        Text(
                                            '${estudiante.nivel}-${estudiante.numero}')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Asignacion:'),
                                        const SizedBox(width: 10),
                                        Text(estudiante.sede,
                                            style: const TextStyle(
                                                color: Colors.green))
                                      ],
                                    ),
                                    const Divider()
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: SpinKitCircle(
                      color: Colors.greenAccent, // Color de la animación
                      size: 50.0, // Tamaño del widget
                    ),
                  )));
  }
}
