// To parse this JSON data, do
//
//     final modeloConvivencia = modeloConvivenciaFromJson(jsonString);

import 'dart:convert';

ModeloConvivencia modeloConvivenciaFromJson(String str) =>
    ModeloConvivencia.fromJson(json.decode(str));

String modeloConvivenciaToJson(ModeloConvivencia data) =>
    json.encode(data.toMap());

class ModeloConvivencia {
  String ind;
  String estudiante;
  String nombres;
  String grupo;
  String sede;
  String asignatura;
  String fecha;
  String hora;
  String tipoFalta;
  String firmado;
  String firma;

  ModeloConvivencia({
    required this.ind,
    required this.estudiante,
    required this.nombres,
    required this.grupo,
    required this.sede,
    required this.asignatura,
    required this.fecha,
    required this.hora,
    required this.tipoFalta,
    required this.firmado,
    required this.firma,
  });

  factory ModeloConvivencia.fromJson(Map<String, dynamic> json) =>
      ModeloConvivencia(
        ind: json["ind"],
        estudiante: json["estudiante"],
        nombres: json["nombres"],
        grupo: json["grupo"],
        sede: json["sede"],
        asignatura: json["asignatura"],
        fecha: json["fecha"],
        hora: json["hora"],
        tipoFalta: json["tipoFalta"],
        firmado: json["firmado"],
        firma: json["firma"],
      );

  Map<String, dynamic> toMap() => {
        "ind": ind,
        "estudiante": estudiante,
        "nombres": nombres,
        "grupo": grupo,
        "sede": sede,
        "asignatura": asignatura,
        "fecha": fecha,
        "hora": hora,
        "tipoFalta": tipoFalta,
        "firmado": firmado,
        "firma": firma,
      };
}
