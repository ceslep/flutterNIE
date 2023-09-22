class ModeloInasistencias {
  String ind;
  String estudiante;
  String nivel;
  String numero;
  String asignacion;
  String materia;
  String periodo;
  String fecha;
  String horas;
  String excusa;
  String docente;
  String horaClase;
  String convivencia;
  String fechahora;
  String detalle;
  String year;

  ModeloInasistencias({
    required this.ind,
    required this.estudiante,
    required this.nivel,
    required this.numero,
    required this.asignacion,
    required this.materia,
    required this.periodo,
    required this.fecha,
    required this.horas,
    required this.excusa,
    required this.docente,
    required this.horaClase,
    required this.convivencia,
    required this.fechahora,
    required this.detalle,
    required this.year,
  });

  factory ModeloInasistencias.fromJson(Map<String, dynamic> json) {
    return ModeloInasistencias(
      ind: json['ind'] ?? '',
      estudiante: json['estudiante'] ?? '',
      nivel: json['nivel'] ?? '',
      numero: json['numero'] ?? '',
      asignacion: json['asignacion'] ?? '',
      materia: json['materia'] ?? '',
      periodo: json['periodo'] ?? '',
      fecha: json['fecha'] ?? '',
      horas: json['horas'] ?? '',
      excusa: json['excusa'] ?? '',
      docente: json['docente'] ?? '',
      horaClase: json['hora_clase'] ?? '',
      convivencia: json['convivencia'] ?? '',
      fechahora: json['fechahora'] ?? '',
      detalle: json['detalle'] ?? '',
      year: json['year'] ?? '',
    );
  }
}
