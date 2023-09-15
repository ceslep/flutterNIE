import 'package:flutter/material.dart';

class EstudianteProvider extends ChangeNotifier {
  String _estudiante = "";

  get estudiante => _estudiante;

  void setEstudiante(String estudiante) {
    _estudiante = estudiante;
    notifyListeners();
  }

  // Otros métodos para modificar la lista de tareas
}
