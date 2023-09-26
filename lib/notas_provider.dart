// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'modelo_notas.dart';

const String urlbase = 'https://app.iedeoccidente.com';

class NotasProvider extends ChangeNotifier {
  List<ModeloNotas> _data = [];

  List<ModeloNotas> get data => _data;

  void setData(List<Map<String, dynamic>> jsonData) {
    if (jsonData.isEmpty) {
      return;
    }
    _data = jsonData.map((json) => ModeloNotas.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> updateData(String usuario) async {
    final List<Map<String, dynamic>> data =
        await fetchDataFromJson(usuario, usuario);
    print({'data': data.length});
    setData(data);
  }

  Future<List<Map<String, dynamic>>> fetchDataFromJson(
      String usuario, String pass) async {
    final url = Uri.parse('$urlbase/est/php/login.php');

    final bodyData = json.encode({'identificacion': usuario, 'pass': pass});
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['acceso'] == 'si') {
        final dataNotas = jsonResponse['dataNotas'] as List<dynamic>;
        final listaNotas =
            dataNotas.map((item) => item as Map<String, dynamic>).toList();
        return listaNotas;
      }
    }
    throw Exception('La solicitud falló o la respuesta no es la esperada');
  }
}
