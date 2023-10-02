import 'package:flutter/material.dart';

class ListaEstudiantes extends StatefulWidget {
  const ListaEstudiantes({Key? key}) : super(key: key);

  @override
  State<ListaEstudiantes> createState() => _ListaEstudiantesState();
}

class _ListaEstudiantesState extends State<ListaEstudiantes> {
  TextEditingController searchController = TextEditingController();
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
            body: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Buscar",
                  ),
                )
              ],
            )));
  }
}
