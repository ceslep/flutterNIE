// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notas_ie/convivencia_provider.dart';
import 'package:notas_ie/inasistencias_provider.dart';
import 'package:notas_ie/main.dart';
import 'package:notas_ie/modelo_Convivencia.dart';
import 'package:notas_ie/modelo_inasistencias.dart';
import 'package:notas_ie/modelo_notas.dart';
import 'package:notas_ie/notas_provider.dart';
import 'package:notas_ie/widgets/concentrador.dart';
import 'package:notas_ie/widgets/convivencia.dart';
import 'package:notas_ie/widgets/desi_alert.dart';
import 'package:notas_ie/widgets/inasistencias.dart';
import 'package:notas_ie/widgets/menu_periodos.dart';
import 'package:notas_ie/widgets/nota_list_tile.dart';
import 'package:provider/provider.dart';
import '../estudiante_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntradaApp extends StatefulWidget {
  final String elPeriodo;
  const EntradaApp({super.key, required this.elPeriodo});

  @override
  State<EntradaApp> createState() => _EntradaAppState();
}

class _EntradaAppState extends State<EntradaApp>
    with SingleTickerProviderStateMixin {
  bool salida = false;
  String periodo = "";
  late EstudianteProvider estudianteProvider;
  late NotasProvider notasProvider;
  late InasistenciasProvider inasistenciasProvider;
  late ConvivenciaProvider convivenciaProvider;
  late List<ModeloNotas> listaDeNotas = notasProvider.data;
  late List<String> periodos;
  late List<String> asignaturas;
  late List<ModeloNotas> listaDeNotasFiltradas;
  late List<ModeloInasistencias> listaInasistencias;
  List<ModeloConvivencia> listaConvivencia = [];

  Future<void> guardarValorLocal(String estudiante) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estudiante',
        estudiante); // Reemplaza 'clave' por tu clave y true por el valor que desees almacenar
  }

  Future<void> init() async {
    estudianteProvider =
        Provider.of<EstudianteProvider>(context, listen: false);
    periodo =
        widget.elPeriodo == '' ? estudianteProvider.periodo : widget.elPeriodo;
    notasProvider = Provider.of<NotasProvider>(context, listen: false);
    listaDeNotas = notasProvider.data;
    print({'ln': listaDeNotas.length});
    listaDeNotasFiltradas =
        listaDeNotas.where((nota) => nota.periodo == periodo).toList();
    print({'nf': listaDeNotasFiltradas.length});

    periodos = listaDeNotas.map((e) => e.periodo).toSet().toList();
    if (!periodos.contains(periodo)) {
      periodos.add(periodo);
    }
    asignaturas = listaDeNotas.map((e) => e.asignatura).toSet().toList();
    inasistenciasProvider =
        Provider.of<InasistenciasProvider>(context, listen: false);
    listaInasistencias = inasistenciasProvider.data;

    convivenciaProvider =
        Provider.of<ConvivenciaProvider>(context, listen: false);
    await convivenciaProvider.updateData(
        estudianteProvider.estudiante, (DateTime.now()).year.toString());
    listaConvivencia = convivenciaProvider.data;
  }

  static const List<Tab> tabs = <Tab>[
    Tab(
      icon: Icon(Icons.calculate_sharp),
    ),
    Tab(
      icon: Icon(Icons.access_time_filled),
    ),
    Tab(
      icon: Icon(Icons.settings_accessibility),
    ),
    Tab(
      icon: Icon(Icons.grid_4x4),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    init();
  }

  void salir() {
    print({"salir": salida});
    if (salida) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent)),
      home: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                _tabController.index = 0;
                bool result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Row(
                        children: [
                          Icon(Icons.info,
                              color: Color.fromARGB(255, 126, 115, 15)),
                          Text('Cerrar'),
                        ],
                      ),
                      content: const Row(
                        children: [
                          Text('Desea cerrar sesión'),
                          Icon(
                            Icons.question_mark,
                            color: Colors.red,
                          )
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancelar')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Aceptar')),
                      ],
                    );
                  },
                );
                if (result) {
                  notasProvider.setData([]);
                  inasistenciasProvider.setData([]);
                  convivenciaProvider.setData([]);
                  estudianteProvider.setEstudiante("");
                  estudianteProvider.setGrado("");
                  estudianteProvider.setNombresEstudiante("");
                  estudianteProvider.setPeriodo("");
                  listaConvivencia = [];
                  listaInasistencias = [];
                  setState(() {});

                  guardarValorLocal("").then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainApp()));
                  });
                }
              },
            ),
            backgroundColor: Colors.lightBlueAccent,
            bottom: TabBar(
              onTap: (index) async {
                listaConvivencia = [];
                await actualizar();
                setState(() {});
              },
              controller: _tabController,
              tabs: tabs,
            ),
            title: const Text('Notas IedeOccidente'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print('hola');
                      await actualizar();
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.face_6_outlined, color: Colors.green),
                        Text(
                          estudianteProvider.nombres ?? "",
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(estudianteProvider.grado,
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  periodos.isNotEmpty
                      ? DropdownButtonWidget(
                          items: periodos,
                          onChanged: (String value) {
                            setState(() {
                              periodo = value;
                              listaDeNotasFiltradas = listaDeNotas
                                  .where((nota) => nota.periodo == periodo)
                                  .toList();
                            });
                          },
                          defaultValue: periodo,
                        )
                      : const Text(''),
                  Expanded(
                    child: listaDeNotasFiltradas.isEmpty
                        ? const Center(child: Text('No hay notas'))
                        : RefreshIndicator(
                            color: Colors.white,
                            backgroundColor: Colors.blue,
                            strokeWidth: 4.0,
                            onRefresh: () async {
                              await actualizar();
                              setState(() {});
                            },
                            child: ListView.builder(
                              itemCount: listaDeNotasFiltradas.length,
                              itemBuilder: (context, index) {
                                /* if (index.isOdd) return const Divider();
                                  final indexs = index ~/ 2; */
                                final nota = listaDeNotasFiltradas[index];

                                final List<ModeloNotas> detalleNotas =
                                    listaDeNotasFiltradas
                                        .where((detalle) =>
                                            detalle.asignatura ==
                                            nota.asignatura)
                                        .toList();
                                if (detalleNotas.isNotEmpty) {
                                  print({
                                    'asignatura': detalleNotas[0].asignatura,
                                    'periodo': detalleNotas[0].periodo
                                  });
                                }
                                return NotaListTile(
                                    nota: nota, notas: detalleNotas);
                              },
                            ),
                          ),
                  ),
                ],
              ),
              Inasistencias(
                  inasistencias: listaInasistencias, periodoActual: periodo),
              Convivencia(convivencia: listaConvivencia),
              Concentrador(
                notasPeriodos: listaDeNotas,
                periodos: periodos,
                asignaturas: asignaturas,
              )
              // Elimina la pestaña adicional
            ],
          ),
        ),
      ),
    );
  }

  Future<void> actualizar() async {
    await notasProvider.updateData(estudianteProvider.estudiante).then((_) {
      listaDeNotas = notasProvider.data;
      listaDeNotasFiltradas =
          listaDeNotas.where((nota) => nota.periodo == periodo).toList();
      periodos = listaDeNotas.map((e) => e.periodo).toSet().toList();
      if (!periodos.contains(periodo)) {
        periodos.add(periodo);
      }
    });
  }

  Future<bool> mostrarAlert(BuildContext context, String title, String text) {
    bool value = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DAlertDialog(
          key: const Key('dalert'),
          title: title,
          content: text,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                value = false;
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                value = true;
                print("si");
              },
              child: const Text('Si'),
            )
          ],
        );
      },
    );
    return Future.value(value);
  }
}
