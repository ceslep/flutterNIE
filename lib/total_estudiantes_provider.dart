// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:notas_ie/modelo_Estudiantes.dart';

const String urlbase = 'https://app.iedeoccidente.com';

class TotalEstudiantesProvider extends ChangeNotifier {
  List<Estudiantes> _data = [];

  List<Estudiantes> get data => _data;

  void setData(List<Map<String, dynamic>> jsonData) {
    if (jsonData.isEmpty) {
      return;
    }
    _data = jsonData.map((json) => Estudiantes.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> updateData() async {
    final List<Map<String, dynamic>> data = await fetchDataFromJson();
    print({'datar': data.length});
    setData(data);
  }

  Future<List<Map<String, dynamic>>> fetchDataFromJson() async {
    final url = Uri.parse('$urlbase/appold/convivencia/php/getEstudiantes.php');
    final bodyData = json.encode({'identificacion': ''});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final dataTotalEstudiantes = jsonResponse as List<dynamic>;
      final listaTotalEstudiantes = dataTotalEstudiantes
          .map((item) => item as Map<String, dynamic>)
          .toList();
      return listaTotalEstudiantes;
    }
    throw Exception('La solicitud falló o la respuesta no es la esperada');
  }
}
