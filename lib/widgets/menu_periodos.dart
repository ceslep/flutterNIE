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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Período', textAlign: TextAlign.left),
        Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: DropdownButton<String>(
              value: _selectedValue ?? widget.defaultValue,
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                _selectedValue = value;
                widget.onChanged(value!);
              },
            ))
      ],
    );
  }
}
