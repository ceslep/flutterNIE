import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_inasistencias.dart';

class InasistenciasProvider extends ChangeNotifier {
  List<ModeloInasistencias> _data = [];

  List<ModeloInasistencias> get data => _data;

  void setData(List<Map<String, dynamic>> jsonData) {
    if (jsonData.isEmpty) {
      return;
    }
    _data = jsonData.map((json) => ModeloInasistencias.fromJson(json)).toList();
    notifyListeners();
  }
}
