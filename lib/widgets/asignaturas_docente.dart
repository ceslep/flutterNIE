import 'package:flutter/material.dart';

class AsignaturasDocente extends StatefulWidget {
  final List<String> asignaturas;
  final String docente;
  const AsignaturasDocente(
      {Key? key, required this.asignaturas, required this.docente})
      : super(key: key);

  @override
  State<AsignaturasDocente> createState() => _AsignaturasDocenteState();
}

class _AsignaturasDocenteState extends State<AsignaturasDocente> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent)),
        home: Scaffold(
            appBar: AppBar(
              title: Text(widget.docente),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: ListView.builder(
                itemCount: widget.asignaturas.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(widget.asignaturas[index]));
                })));
  }
}
