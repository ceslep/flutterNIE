import 'package:flutter/material.dart';

import 'modelo_notas.dart';

class NotasProvider extends ChangeNotifier {
  List<ModeloNotas> _data = [];

  List<ModeloNotas> get data => _data;

  void setData(List<Map<String, dynamic>> jsonData) {
    // ignore: unnecessary_null_comparison
    if (jsonData == null) {
      return;
    }
    _data = jsonData.map((json) => ModeloNotas.fromJson(json)).toList();
    notifyListeners();
  }
}
