// To parse this JSON data, do
//
//     final estudiantes = estudiantesFromJson(jsonString);

import 'dart:convert';

List<Estudiantes> estudiantesFromJson(String str) => List<Estudiantes>.from(
    json.decode(str).map((x) => Estudiantes.fromJson(x)));

String estudiantesToJson(List<Estudiantes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Estudiantes {
  String ind;
  String codigo;
  String estudiante;
  String nombres;
  String asignacion;
  String genero;
  String nivel;
  String grado;
  String numero;
  String anio;
  String pass;
  String activo;
  String banda;
  String hed;
  String acudiente;
  String telefono1;
  String telefono2;
  String year;
  String sede;

  Estudiantes({
    required this.ind,
    required this.codigo,
    required this.estudiante,
    required this.nombres,
    required this.asignacion,
    required this.genero,
    required this.nivel,
    required this.grado,
    required this.numero,
    required this.anio,
    required this.pass,
    required this.activo,
    required this.banda,
    required this.hed,
    required this.acudiente,
    required this.telefono1,
    required this.telefono2,
    required this.year,
    required this.sede,
  });

  factory Estudiantes.fromJson(Map<String, dynamic> json) => Estudiantes(
        ind: json["ind"],
        codigo: json["codigo"],
        estudiante: json["estudiante"],
        nombres: json["nombres"],
        asignacion: json["asignacion"],
        genero: json["genero"],
        nivel: json["nivel"],
        grado: json["grado"],
        numero: json["numero"],
        anio: json["anio"],
        pass: json["pass"],
        activo: json["activo"],
        banda: json["banda"],
        hed: json["HED"],
        acudiente: json["acudiente"],
        telefono1: json["telefono1"],
        telefono2: json["telefono2"],
        year: json["year"],
        sede: json["sede"],
      );

  Map<String, dynamic> toMap() => {
        "ind": ind,
        "codigo": codigo,
        "estudiante": estudiante,
        "nombres": nombres,
        "asignacion": asignacion,
        "genero": genero,
        "nivel": nivel,
        "grado": grado,
        "numero": numero,
        "anio": anio,
        "pass": pass,
        "activo": activo,
        "banda": banda,
        "HED": hed,
        "acudiente": acudiente,
        "telefono1": telefono1,
        "telefono2": telefono2,
        "year": year,
        "sede": sede,
      };
}
