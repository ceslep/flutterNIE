import 'package:flutter/material.dart';
import 'package:notas_ie/notas_provider.dart';
import 'package:notas_ie/widgets/menu_periodos.dart';
import 'package:provider/provider.dart';
import '../estudiante_provider.dart';

void main() {
  runApp(const EntradaApp());
}

class EntradaApp extends StatefulWidget {
  const EntradaApp({super.key});

  @override
  State<EntradaApp> createState() => _EntradaAppState();
}

class _EntradaAppState extends State<EntradaApp> {
  @override
  Widget build(BuildContext context) {
    final estudianteProvider =
        Provider.of<EstudianteProvider>(context, listen: false);
    final notasProvider = Provider.of<NotasProvider>(context, listen: false);
    final listaDeNotas = notasProvider.data;
    final periodos = listaDeNotas.map((e) => e.periodo).toSet().toList();
    String periodo = estudianteProvider.periodo;
    print(periodos.toSet());

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
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Notas IedeOccidente'),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  const Icon(Icons.directions_car),
                  Text(estudianteProvider.nombres),
                  periodos.isNotEmpty
                      ? DropdownButtonWidget(
                          items: periodos,
                          onChanged: (value) => {},
                          defaultValue: periodo,
                        )
                      : const Text(''),
                  Expanded(
                    child: listaDeNotas.isEmpty
                        ? const Center(child: Text('No hay notas'))
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final nota = listaDeNotas[index];
                              return ListTile(
                                title: Text(nota.asignatura),
                                subtitle: Text(
                                    'Valoración: ${nota.valoracion.toString()}'),
                              );
                            },
                            itemCount: listaDeNotas.length,
                          ),
                  ),
                ],
              ),
              const Icon(Icons.directions_transit),
              const Icon(Icons.directions_bike),
              // Elimina la pestaña adicional
            ],
          ),
        ),
      ),
    );
  }
}
