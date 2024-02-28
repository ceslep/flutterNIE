class NotaIndividual {
  String ind;
  String estudiante;
  String grado;
  String asignatura;
  String docente;
  String periodo;
  double valoracion;
  double nota1;
  double nota2;
  double nota3;
  double nota4;
  String nota5;
  String nota6;
  String nota7;
  String nota8;
  String nota9;
  String nota10;
  String nota11;
  String nota12;
  String porcentaje1;
  String porcentaje2;
  String porcentaje3;
  String porcentaje4;
  String porcentaje5;
  String porcentaje6;
  String porcentaje7;
  String porcentaje8;
  String porcentaje9;
  String porcentaje10;
  String porcentaje11;
  String porcentaje12;
  String aspecto1;
  String aspecto2;
  String aspecto3;
  String aspecto4;
  String aspecto5;
  String aspecto6;
  String aspecto7;
  String aspecto8;
  String aspecto9;
  String aspecto10;
  String aspecto11;
  String aspecto12;
  String fecha1;
  String fecha2;
  String fecha3;
  String fecha4;
  String fecha5;
  String fecha6;
  String fecha7;
  String fecha8;
  String fecha9;
  String fecha10;
  String fecha11;
  String fecha12;
  String anotacion1;
  String anotacion2;
  String anotacion3;
  String anotacion4;
  String anotacion5;
  String anotacion6;
  String anotacion7;
  String anotacion8;
  String anotacion9;
  String anotacion10;
  String anotacion11;
  String anotacion12;
  String fechaa1;
  String fechaa2;
  String fechaa3;
  String fechaa4;
  String fechaa5;
  String fechaa6;
  String fechaa7;
  String fechaa8;
  String fechaa9;
  String fechaa10;
  String fechaa11;
  String fechaa12;
  String fechahora;
  String year;

  NotaIndividual.fromJson(Map<String, dynamic> json)
      : ind = json['ind'],
        estudiante = json['estudiante'],
        grado = json['grado'],
        asignatura = json['asignatura'],
        docente = json['docente'],
        periodo = json['periodo'],
        valoracion = json['valoracion'].toDouble(),
        nota1 = json['nota1'].toDouble(),
        nota2 = json['nota2'].toDouble(),
        nota3 = json['nota3'].toDouble(),
        nota4 = json['nota4'].toDouble(),
        nota5 = json['nota5'],
        nota6 = json['nota6'],
        nota7 = json['nota7'],
        nota8 = json['nota8'],
        nota9 = json['nota9'],
        nota10 = json['nota10'],
        nota11 = json['nota11'],
        nota12 = json['nota12'],
        porcentaje1 = json['porcentaje1'],
        porcentaje2 = json['porcentaje2'],
        porcentaje3 = json['porcentaje3'],
        porcentaje4 = json['porcentaje4'],
        porcentaje5 = json['porcentaje5'],
        porcentaje6 = json['porcentaje6'],
        porcentaje7 = json['porcentaje7'],
        porcentaje8 = json['porcentaje8'],
        porcentaje9 = json['porcentaje9'],
        porcentaje10 = json['porcentaje10'],
        porcentaje11 = json['porcentaje11'],
        porcentaje12 = json['porcentaje12'],
        aspecto1 = json['aspecto1'],
        aspecto2 = json['aspecto2'],
        aspecto3 = json['aspecto3'],
        aspecto4 = json['aspecto4'],
        aspecto5 = json['aspecto5'],
        aspecto6 = json['aspecto6'],
        aspecto7 = json['aspecto7'],
        aspecto8 = json['aspecto8'],
        aspecto9 = json['aspecto9'],
        aspecto10 = json['aspecto10'],
        aspecto11 = json['aspecto11'],
        aspecto12 = json['aspecto12'],
        fecha1 = json['fecha1'],
        fecha2 = json['fecha2'],
        fecha3 = json['fecha3'],
        fecha4 = json['fecha4'],
        fecha5 = json['fecha5'],
        fecha6 = json['fecha6'],
        fecha7 = json['fecha7'],
        fecha8 = json['fecha8'],
        fecha9 = json['fecha9'],
        fecha10 = json['fecha10'],
        fecha11 = json['fecha11'],
        fecha12 = json['fecha12'],
        anotacion1 = json['anotacion1'],
        anotacion2 = json['anotacion2'],
        anotacion3 = json['anotacion3'],
        anotacion4 = json['anotacion4'],
        anotacion5 = json['anotacion5'],
        anotacion6 = json['anotacion6'],
        anotacion7 = json['anotacion7'],
        anotacion8 = json['anotacion8'],
        anotacion9 = json['anotacion9'],
        anotacion10 = json['anotacion10'],
        anotacion11 = json['anotacion11'],
        anotacion12 = json['anotacion12'],
        fechaa1 = json['fechaa1'],
        fechaa2 = json['fechaa2'],
        fechaa3 = json['fechaa3'],
        fechaa4 = json['fechaa4'],
        fechaa5 = json['fechaa5'],
        fechaa6 = json['fechaa6'],
        fechaa7 = json['fechaa7'],
        fechaa8 = json['fechaa8'],
        fechaa9 = json['fechaa9'],
        fechaa10 = json['fechaa10'],
        fechaa11 = json['fechaa11'],
        fechaa12 = json['fechaa12'],
        fechahora = json['fechahora'],
        year = json['year'];

  Map<String, dynamic> toJson() => {
        'ind': ind,
        'estudiante': estudiante,
        'grado': grado,
        'asignatura': asignatura,
        'docente': docente,
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
