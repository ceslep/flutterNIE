// To parse this JSON data, do
//
//     final aspectos = aspectosFromJson(jsonString);

import 'dart:convert';

MAspectos aspectosFromJson(String str) => MAspectos.fromJson(json.decode(str));

String aspectosToJson(MAspectos data) => json.encode(data.toJson());

class MAspectos {
  String ind;
  String docente;
  String grado;
  String periodo;
  String asignatura;
  String aspecto;
  String porcentaje;
  String fecha;
  String nota;
  String year;
  String fechahora;

  MAspectos({
    required this.ind,
    required this.docente,
    required this.grado,
    required this.periodo,
    required this.asignatura,
    required this.aspecto,
    required this.porcentaje,
    required this.fecha,
    required this.nota,
    required this.year,
    required this.fechahora,
  });

  factory MAspectos.fromJson(Map<String, dynamic> json) => MAspectos(
        ind: json["ind"],
        docente: json["docente"],
        grado: json["grado"],
        periodo: json["periodo"],
        asignatura: json["asignatura"],
        aspecto: json["aspecto"],
        porcentaje: json["porcentaje"] ?? '',
        fecha: json["fecha"] ?? '',
        nota: json["nota"],
        year: json["year"],
        fechahora: json["fechahora"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ind": ind,
        "docente": docente,
        "grado": grado,
        "periodo": periodo,
        "asignatura": asignatura,
        "aspecto": aspecto,
        "porcentaje": porcentaje,
        "fecha": fecha,
        "nota": nota,
        "year": year,
        "fechahora": fechahora
      };
}
