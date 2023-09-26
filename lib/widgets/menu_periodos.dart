// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String defaultValue;
  const DropdownButtonWidget(
      {Key? key,
      required this.items,
      required this.onChanged,
      required this.defaultValue})
      : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          child: const Row(
            children: [Text('Período', textAlign: TextAlign.left)],
          ),
        ),
        Container(
            padding: const EdgeInsets.only(left: 16),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _selectedValue,
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 141, 0, 122),
                          fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(
                    value!); // Llama a la función de callback con el valor seleccionado
              },
            ))
      ],
    );
  }
}
