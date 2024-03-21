import 'package:flutter/material.dart';

class ListadoFaltas extends StatefulWidget {
  final List<String> faltas;
  const ListadoFaltas({super.key, required this.faltas});

  @override
  State<ListadoFaltas> createState() => _ListadoFaltasState();
}

class _ListadoFaltasState extends State<ListadoFaltas> {
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    super.initState();
    _isCheckedList = List<bool>.filled(widget.faltas.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione las Faltas'),
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => CheckboxListTile(
          value: _isCheckedList[index],
          title: Text(widget.faltas[index]),
          onChanged: (value) {
            setState(() {
              _isCheckedList[index] =
                  value!; // Actualizar el estado de selección
            });
          },
        ),
        itemCount: widget.faltas.length,
      ),
    );
  }
}
