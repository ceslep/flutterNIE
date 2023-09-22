class ModeloNotas {
  final String ind;
  final String estudiante;
  final String grado;
  final String asignatura;
  final String docente;
  final String nombresDocente;
  final String periodo;
  final String valoracion;
  final String nota1;
  final String nota2;
  final String nota3;
  final String nota4;
  final String nota5;
  final String nota6;
  final String nota7;
  final String nota8;
  final String nota9;
  final String nota10;
  final String nota11;
  final String? nota12;
  final String? porcentaje1;
  final String? porcentaje2;
  final String? porcentaje3;
  final String? porcentaje4;
  final String? porcentaje5;
  final String? porcentaje6;
  final String? porcentaje7;
  final String? porcentaje8;
  final String? porcentaje9;
  final String? porcentaje10;
  final String? porcentaje11;
  final String? porcentaje12;
  final String aspecto1;
  final String aspecto2;
  final String aspecto3;
  final String aspecto4;
  final String aspecto5;
  final String aspecto6;
  final String aspecto7;
  final String aspecto8;
  final String aspecto9;
  final String aspecto10;
  final String aspecto11;
  final String? aspecto12;
  final String fecha1;
  final String fecha2;
  final String fecha3;
  final String fecha4;
  final String fecha5;
  final String fecha6;
  final String fecha7;
  final String fecha8;
  final String fecha9;
  final String fecha10;
  final String fecha11;
  final String? fecha12;
  final String? anotacion1;
  final String? anotacion2;
  final String? anotacion3;
  final String? anotacion4;
  final String? anotacion5;
  final String? anotacion6;
  final String? anotacion7;
  final String? anotacion8;
  final String? anotacion9;
  final String? anotacion10;
  final String? anotacion11;
  final String? anotacion12;
  final String fechaa1;
  final String fechaa2;
  final String fechaa3;
  final String fechaa4;
  final String fechaa5;
  final String fechaa6;
  final String fechaa7;
  final String fechaa8;
  final String fechaa9;
  final String fechaa10;
  final String fechaa11;
  final String? fechaa12;
  final String fechahora;
  final String year;

  ModeloNotas({
    required this.ind,
    required this.estudiante,
    required this.grado,
    required this.asignatura,
    required this.docente,
    required this.nombresDocente,
    required this.periodo,
    required this.valoracion,
    required this.nota1,
    required this.nota2,
    required this.nota3,
    required this.nota4,
    required this.nota5,
    required this.nota6,
    required this.nota7,
    required this.nota8,
    required this.nota9,
    required this.nota10,
    required this.nota11,
    this.nota12,
    this.porcentaje1,
    this.porcentaje2,
    this.porcentaje3,
    this.porcentaje4,
    this.porcentaje5,
    this.porcentaje6,
    this.porcentaje7,
    this.porcentaje8,
    this.porcentaje9,
    this.porcentaje10,
    this.porcentaje11,
    this.porcentaje12,
    required this.aspecto1,
    required this.aspecto2,
    required this.aspecto3,
    required this.aspecto4,
    required this.aspecto5,
    required this.aspecto6,
    required this.aspecto7,
    required this.aspecto8,
    required this.aspecto9,
    required this.aspecto10,
    required this.aspecto11,
    this.aspecto12,
    required this.fecha1,
    required this.fecha2,
    required this.fecha3,
    required this.fecha4,
    required this.fecha5,
    required this.fecha6,
    required this.fecha7,
    required this.fecha8,
    required this.fecha9,
    required this.fecha10,
    required this.fecha11,
    this.fecha12,
    this.anotacion1,
    this.anotacion2,
    this.anotacion3,
    this.anotacion4,
    this.anotacion5,
    this.anotacion6,
    this.anotacion7,
    this.anotacion8,
    this.anotacion9,
    this.anotacion10,
    this.anotacion11,
    this.anotacion12,
    required this.fechaa1,
    required this.fechaa2,
    required this.fechaa3,
    required this.fechaa4,
    required this.fechaa5,
    required this.fechaa6,
    required this.fechaa7,
    required this.fechaa8,
    required this.fechaa9,
    required this.fechaa10,
    required this.fechaa11,
    this.fechaa12,
    required this.fechahora,
    required this.year,
  });

  factory ModeloNotas.fromJson(Map<String, dynamic> json) {
    return ModeloNotas(
      ind: json['ind'],
      estudiante: json['estudiante'],
      grado: json['grado'],
      asignatura: json['asignatura'],
      docente: json['docente'],
      nombresDocente: json['nombresDocente'],
      periodo: json['periodo'],
      valoracion: json['valoracion'] ?? '',
      nota1: json['nota1'] ?? '',
      nota2: json['nota2'] ?? '',
      nota3: json['nota3'] ?? '',
      nota4: json['nota4'] ?? '',
      nota5: json['nota5'] ?? '',
      nota6: json['nota6'] ?? '',
      nota7: json['nota7'] ?? '',
      nota8: json['nota8'] ?? '',
      nota9: json['nota9'] ?? '',
      nota10: json['nota10'] ?? '',
      nota11: json['nota11'] ?? '',
      nota12: json['nota12'] ?? '',
      porcentaje1: json['porcentaje1'] ?? '',
      porcentaje2: json['porcentaje2'] ?? '',
      porcentaje3: json['porcentaje3'] ?? '',
      porcentaje4: json['porcentaje4'] ?? '',
      porcentaje5: json['porcentaje5'] ?? '',
      porcentaje6: json['porcentaje6'] ?? '',
      porcentaje7: json['porcentaje7'] ?? '',
      porcentaje8: json['porcentaje8'] ?? '',
      porcentaje9: json['porcentaje9'] ?? '',
      porcentaje10: json['porcentaje10'] ?? '',
      porcentaje11: json['porcentaje11'] ?? '',
      porcentaje12: json['porcentaje12'] ?? '',
      aspecto1: json['aspecto1'] ?? '',
      aspecto2: json['aspecto2'] ?? '',
      aspecto3: json['aspecto3'] ?? '',
      aspecto4: json['aspecto4'] ?? '',
      aspecto5: json['aspecto5'] ?? '',
      aspecto6: json['aspecto6'] ?? '',
      aspecto7: json['aspecto7'] ?? '',
      aspecto8: json['aspecto8'] ?? '',
      aspecto9: json['aspecto9'] ?? '',
      aspecto10: json['aspecto10'] ?? '',
      aspecto11: json['aspecto11'] ?? '',
      aspecto12: json['aspecto12'] ?? '',
      fecha1: json['fecha1'] ?? '',
      fecha2: json['fecha2'] ?? '',
      fecha3: json['fecha3'] ?? '',
      fecha4: json['fecha4'] ?? '',
      fecha5: json['fecha5'] ?? '',
      fecha6: json['fecha6'] ?? '',
      fecha7: json['fecha7'] ?? '',
      fecha8: json['fecha8'] ?? '',
      fecha9: json['fecha9'] ?? '',
      fecha10: json['fecha10'] ?? '',
      fecha11: json['fecha11'] ?? '',
      fecha12: json['fecha12'] ?? '',
      anotacion1: json['anotacion1'] ?? '',
      anotacion2: json['anotacion2'] ?? '',
      anotacion3: json['anotacion3'] ?? '',
      anotacion4: json['anotacion4'] ?? '',
      anotacion5: json['anotacion5'] ?? '',
      anotacion6: json['anotacion6'] ?? '',
      anotacion7: json['anotacion7'] ?? '',
      anotacion8: json['anotacion8'] ?? '',
      anotacion9: json['anotacion9'] ?? '',
      anotacion10: json['anotacion10'] ?? '',
      anotacion11: json['anotacion11'] ?? '',
      anotacion12: json['anotacion12'] ?? '',
      fechaa1: json['fechaa1'] ?? '',
      fechaa2: json['fechaa2'] ?? '',
      fechaa3: json['fechaa3'] ?? '',
      fechaa4: json['fechaa4'] ?? '',
      fechaa5: json['fechaa5'] ?? '',
      fechaa6: json['fechaa6'] ?? '',
      fechaa7: json['fechaa7'] ?? '',
      fechaa8: json['fechaa8'] ?? '',
      fechaa9: json['fechaa9'] ?? '',
      fechaa10: json['fechaa10'] ?? '',
      fechaa11: json['fechaa11'] ?? '',
      fechaa12: json['fechaa12'] ?? '',
      fechahora: json['fechahora'] ?? '',
      year: json['year'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ind': ind,
      'estudiante': estudiante,
      'grado': grado,
      'asignatura': asignatura,
      'docente': docente,
      'nombresDocente': nombresDocente,
      'periodo': periodo,
      'valoracion': valoracion,
      'nota1': nota1,
      'nota2': nota2,
      'nota3': nota3,
      'nota4': nota4,
      'nota5': nota5,
      'nota6': nota6,
      'nota7': nota7,
      'nota8': nota8,
      'nota9': nota9,
      'nota10': nota10,
      'nota11': nota11,
      'nota12': nota12,
      'porcentaje1': porcentaje1,
      'porcentaje2': porcentaje2,
      'porcentaje3': porcentaje3,
      'porcentaje4': porcentaje4,
      'porcentaje5': porcentaje5,
      'porcentaje6': porcentaje6,
      'porcentaje7': porcentaje7,
      'porcentaje8': porcentaje8,
      'porcentaje9': porcentaje9,
      'porcentaje10': porcentaje10,
      'porcentaje11': porcentaje11,
      'porcentaje12': porcentaje12,
      'aspecto1': aspecto1,
      'aspecto2': aspecto2,
      'aspecto3': aspecto3,
      'aspecto4': aspecto4,
      'aspecto5': aspecto5,
      'aspecto6': aspecto6,
      'aspecto7': aspecto7,
      'aspecto8': aspecto8,
      'aspecto9': aspecto9,
      'aspecto10': aspecto10,
      'aspecto11': aspecto11,
      'aspecto12': aspecto12,
      'fecha1': fecha1,
      'fecha2': fecha2,
      'fecha3': fecha3,
      'fecha4': fecha4,
      'fecha5': fecha5,
      'fecha6': fecha6,
      'fecha7': fecha7,
      'fecha8': fecha8,
      'fecha9': fecha9,
      'fecha10': fecha10,
      'fecha11': fecha11,
      'fecha12': fecha12,
      'anotacion1': anotacion1,
      'anotacion2': anotacion2,
      'anotacion3': anotacion3,
      'anotacion4': anotacion4,
      'anotacion5': anotacion5,
      'anotacion6': anotacion6,
      'anotacion7': anotacion7,
      'anotacion8': anotacion8,
      'anotacion9': anotacion9,
      'anotacion10': anotacion10,
      'anotacion11': anotacion11,
      'anotacion12': anotacion12,
      'fechaa1': fechaa1,
      'fechaa2': fechaa2,
      'fechaa3': fechaa3,
      'fechaa4': fechaa4,
      'fechaa5': fechaa5,
      'fechaa6': fechaa6,
      'fechaa7': fechaa7,
      'fechaa8': fechaa8,
      'fechaa9': fechaa9,
      'fechaa10': fechaa10,
      'fechaa11': fechaa11,
      'fechaa12': fechaa12,
      'fechahora': fechahora,
      'year': year,
    };
  }
}
