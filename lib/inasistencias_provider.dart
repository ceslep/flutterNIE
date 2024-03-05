import 'package:com_celesoft_notasieo/modelo_inasistencias.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

class InasistenciasProvider extends ChangeNotifier {
  List<ModeloInasistencias> _data = [];

  List<ModeloInasistencias> get data => _data;

  Future<void> updateData(String estudiante, String year) async {
    final List<Map<String, dynamic>> data =
        await fetchDataFromJson(estudiante, year);
    if (kDebugMode) {
      print({'lengthdatainasistencias': data.length});
    }
    setData(data);
  }

  void setData(List<Map<String, dynamic>> jsonData) {
    if (jsonData.isEmpty) {
      return;
    }
    _data = jsonData.map((json) => ModeloInasistencias.fromJson(json)).toList();
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchDataFromJson(
      String estudiante, String year) async {
    final url = Uri.parse('$urlbase/est/php/getInasist.php');

    final bodyData = json.encode({'estudiante': estudiante, 'year': year});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final dataInasistencias = jsonResponse as List<dynamic>;
      final listaInasistencias = dataInasistencias
          .map((item) => item as Map<String, dynamic>)
          .toList();
      return listaInasistencias;
    }
    throw Exception('La solicitud falló o la respuesta no es la esperada');
  }
}
