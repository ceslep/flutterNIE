// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:notas_ie/inasistencias_provider.dart';
import 'package:notas_ie/modelo_inasistencias.dart';
import 'package:notas_ie/modelo_notas.dart';
import 'package:notas_ie/notas_provider.dart';
import 'package:notas_ie/widgets/inasistencias.dart';
import 'package:notas_ie/widgets/menu_periodos.dart';
import 'package:notas_ie/widgets/nota_list_tile.dart';
import 'package:provider/provider.dart';
import '../estudiante_provider.dart';

class EntradaApp extends StatefulWidget {
  const EntradaApp({super.key});

  @override
  State<EntradaApp> createState() => _EntradaAppState();
}

class _EntradaAppState extends State<EntradaApp> {
  String periodo = "";
  late EstudianteProvider estudianteProvider;
  late NotasProvider notasProvider;
  late InasistenciasProvider inasistenciasProvider;
  late List<ModeloNotas> listaDeNotas = notasProvider.data;
  late List<String> periodos;
  late List<ModeloNotas> listaDeNotasFiltradas;
  late List<ModeloInasistencias> listaInasistencias;

  @override
  void initState() {
    super.initState();
    estudianteProvider =
        Provider.of<EstudianteProvider>(context, listen: false);
    periodo = estudianteProvider.periodo;
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
    inasistenciasProvider =
        Provider.of<InasistenciasProvider>(context, listen: false);
    listaInasistencias = inasistenciasProvider.data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent)),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.lightBlueAccent,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.calculate_sharp, color: Colors.yellowAccent),
                  child: Text('Notas', style: TextStyle(color: Colors.yellow)),
                ),
                Tab(
                    icon: Icon(Icons.access_time_filled),
                    child: Text('Inasistencias')),
                Tab(
                    icon: Icon(Icons.settings_accessibility),
                    child: Text('Convivencia')),
              ],
            ),
            title: const Text('Notas IedeOccidente'),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  const Icon(Icons.directions_car),
                  Text(
                    estudianteProvider.nombres ?? "",
                    style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
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
                        : ListView.builder(
                            itemCount: listaDeNotasFiltradas.length,
                            itemBuilder: (context, index) {
                              /* if (index.isOdd) return const Divider();
                              final indexs = index ~/ 2; */
                              final nota = listaDeNotasFiltradas[index];
                              final List<ModeloNotas> detalleNotas =
                                  listaDeNotasFiltradas
                                      .where((detalle) =>
                                          detalle.asignatura == nota.asignatura)
                                      .toList();

                              return NotaListTile(
                                  nota: nota, notas: detalleNotas);
                            },
                          ),
                  ),
                ],
              ),
              const Inasistencias(),
              const Icon(Icons.directions_bike),
              // Elimina la pestaña adicional
            ],
          ),
        ),
      ),
    );
  }
}
