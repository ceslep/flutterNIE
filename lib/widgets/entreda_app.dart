import 'package:flutter/material.dart';

void main() {
  runApp(const EntradaApp());
}

class EntradaApp extends StatelessWidget {
  const EntradaApp({super.key});

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
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Notas IedeOccidente'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
