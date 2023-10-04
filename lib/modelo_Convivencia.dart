// To parse this JSON data, do
//
//     final modeloConvivencia = modeloConvivenciaFromJson(jsonString);

import 'dart:convert';

ModeloConvivencia modeloConvivenciaFromJson(String str) =>
    ModeloConvivencia.fromJson(json.decode(str));

String modeloConvivenciaToJson(ModeloConvivencia data) =>
    json.encode(data.toMap());

class ModeloConvivencia {
  String ind = '';
  String estudiante = '';
  String docente = '';
  String nombresDocente = '';
  String asignatura = '';
  String tipoFalta = '';
  String faltas = '';
  String hora = '';
  String fecha = '';
  String descripcionSituacion = '';
  String descargosEstudiante = '';
  String positivos = '';
  String firma = '';
  String firmaAcudiente = '';
  String fechahora = '';
  String year = '';

  ModeloConvivencia({
    required this.ind,
    required this.estudiante,
    required this.docente,
    required this.nombresDocente,
    required this.asignatura,
    required this.tipoFalta,
    required this.faltas,
    required this.hora,
    required this.fecha,
    required this.descripcionSituacion,
    required this.descargosEstudiante,
    required this.positivos,
    required this.firma,
    required this.firmaAcudiente,
    required this.fechahora,
    required this.year,
  });

  factory ModeloConvivencia.fromJson(Map<String, dynamic> json) =>
      ModeloConvivencia(
        ind: json["ind"],
        estudiante: json["estudiante"],
        docente: json["docente"],
        nombresDocente: json['nombresDocente'],
        asignatura: json["asignatura"],
        tipoFalta: json["tipoFalta"],
        faltas: json["faltas"],
        hora: json["hora"],
        fecha: json["fecha"],
        descripcionSituacion: json["descripcionSituacion"],
        descargosEstudiante: json["descargosEstudiante"],
        positivos: json["positivos"],
        firma: json["firma"],
        firmaAcudiente: json["firmaAcudiente"],
        fechahora: json["fechahora"],
        year: json["year"],
      );

  Map<String, dynamic> toMap() => {
        "ind": ind,
        "estudiante": estudiante,
        "docente": docente,
        "nombresDocente": nombresDocente,
        "asignatura": asignatura,
        "tipoFalta": tipoFalta,
        "faltas": faltas,
        "hora": hora,
        "fecha": fecha,
        "descripcionSituacion": descripcionSituacion,
        "descargosEstudiante": descargosEstudiante,
        "positivos": positivos,
        "firma": firma,
        "firmaAcudiente": firmaAcudiente,
        "fechahora": fechahora,
        "year": year,
      };
}
