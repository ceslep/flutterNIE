import 'package:flutter/material.dart';
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
                  Text(estudianteProvider.estudiante)
                ],
              ),
              const Icon(Icons.directions_transit),
              const Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
