// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class ListadoFaltas extends StatefulWidget {
  final List<String> faltas;
  final List<bool>? checkeds;
  const ListadoFaltas({super.key, required this.faltas, this.checkeds});

  @override
  State<ListadoFaltas> createState() => _ListadoFaltasState();
}

class _ListadoFaltasState extends State<ListadoFaltas> {
  List<bool> _isCheckedList = [];

  @override
  void initState() {
    super.initState();
    print({widget.checkeds});
    if ((widget.checkeds == null)) {
      _isCheckedList = List<bool>.filled(widget.faltas.length, false);
    } else {
      if (widget.checkeds!.isNotEmpty) {
        _isCheckedList = widget.checkeds!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione las Faltas'),
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _isCheckedList),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.done),
              onPressed: () => Navigator.pop(context, _isCheckedList),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Card(
          color: _isCheckedList[index] ? Colors.amber.shade50 : Colors.white,
          child: CheckboxListTile(
            value: _isCheckedList[index],
            title: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${(index + 1).toString()}.',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.faltas[index],
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            onChanged: (value) {
              setState(() {
                _isCheckedList[index] =
                    value!; // Actualizar el estado de selección
              });
            },
          ),
        ),
        itemCount: widget.faltas.length,
      ),
    );
  }
}
