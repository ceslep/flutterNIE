import 'package:flutter/material.dart';

class EntradaDocentes extends StatefulWidget {
  const EntradaDocentes({Key? key}) : super(key: key);

  @override
  State<EntradaDocentes> createState() => _EntradaDocentesState();
}

class _EntradaDocentesState extends State<EntradaDocentes> {
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
            padding: const EdgeInsets.all(16),
            child: const Center(
              child: Text('Docentes'),
            ),
          ),
        ));
  }
}
