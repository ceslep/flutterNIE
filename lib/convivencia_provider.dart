// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Convivencia.dart';

const String urlbase = 'https://app.iedeoccidente.com';

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

  Future<void> updateData(String estudiante, String year) async {
    final List<Map<String, dynamic>> data =
        await fetchDataFromJson(estudiante, year);
    print({'lengthdataconvivencia': data.length});
    setData(data);
  }

  Future<List<Map<String, dynamic>>> fetchDataFromJson(
      String estudiante, String year) async {
    final url = Uri.parse('$urlbase/est/php/getConvivencia.php');

    final bodyData = json.encode({'estudiante': estudiante, 'year': year});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final dataConvivencia = jsonResponse as List<dynamic>;
      final listaConvivencia =
          dataConvivencia.map((item) => item as Map<String, dynamic>).toList();
      return listaConvivencia;
    }
    throw Exception('La solicitud falló o la respuesta no es la esperada');
  }
}
