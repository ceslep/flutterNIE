import 'package:flutter/material.dart';

class EstudProvider extends ChangeNotifier {
  String _estud = '';

  String get estud => _estud;

  void setEstud(String newValue) {
    _estud = newValue;
    notifyListeners();
  }
}
