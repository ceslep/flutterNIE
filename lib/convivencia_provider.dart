import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';

class ConvivenciaProvider extends ChangeNotifier {
  List<ModeloConvivencia> _data = [];

  List<ModeloConvivencia> get data => _data;

  void setData(List<Map<String, dynamic>> jsonData) {
    if (jsonData.isEmpty) {
      return;
    }
    _data = jsonData.map((json) => ModeloConvivencia.fromJson(json)).toList();
    notifyListeners();
  }
}
