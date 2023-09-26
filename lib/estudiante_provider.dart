import 'package:flutter/material.dart';

class EstudianteProvider extends ChangeNotifier {
  String _estudiante = "";
  String _nombresEstudiante = "";
  String _periodo = "";
  String _grado = "";
  get estudiante => _estudiante;
  get nombres => _nombresEstudiante;
  get periodo => _periodo;
  get grado => _grado;
  void setEstudiante(String estudiante) {
    _estudiante = estudiante;
    notifyListeners();
  }

  void setGrado(String grado) {
    _grado = grado;
    notifyListeners();
  }

  void setNombresEstudiante(String nombresEstudiante) {
    _nombresEstudiante = nombresEstudiante;
    notifyListeners();
  }

  void setPeriodo(String periodo) {
    _periodo = periodo;
    notifyListeners();
  }

  // Otros métodos para modificar la lista de tareas
}
