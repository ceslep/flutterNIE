// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notas_ie/estudiante_provider.dart';
import 'package:notas_ie/inasistencias_provider.dart';
import 'package:notas_ie/notas_provider.dart';
import 'package:notas_ie/widgets/custom_alert.dart';
import 'package:notas_ie/widgets/entrada_app.dart';
import 'package:notas_ie/widgets/inasistencias.dart';
import 'package:provider/provider.dart';
import 'widgets/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EstudianteProvider()),
        ChangeNotifierProvider(create: (context) => NotasProvider()),
        ChangeNotifierProvider(create: (context) => InasistenciasProvider())

        // Agrega más providers si es necesario
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PaginaPrincipal(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  LocalStorage storage = LocalStorage('app.json');

  bool login = false;
  //variables de estado
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usuarioController.text = "1054922378";
    passwordController.text = "1054922378";
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> fetchDataFromJson() async {
      final url = Uri.parse('$urlbase/est/php/login.php');

      final bodyData = json.encode({
        'identificacion': usuarioController.text,
        'pass': passwordController.text
      });
      final response = await http.post(url, body: bodyData);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['acceso'] == 'si') {
          final urlInasistencias = Uri.parse('$urlbase/est/php/getInasist.php');
          final bodyDataInasistencias = json.encode({
            'estudiante': usuarioController.text,
          });
          final responseInasistencias =
              await http.post(urlInasistencias, body: bodyDataInasistencias);
          final jsonResponseInasistencias =
              json.decode(responseInasistencias.body);
          //  print(jsonResponse);
          // ignore: use_build_context_synchronously
          final misNotas = Provider.of<NotasProvider>(context, listen: false);
          final dataNotas = jsonResponse['dataNotas'] as List<dynamic>;

// Convierte dataNotas a una lista de Map<String, dynamic>
          final listaNotas =
              dataNotas.map((item) => item as Map<String, dynamic>).toList();

          misNotas.setData(listaNotas);

          final estudianteProvider =
              Provider.of<EstudianteProvider>(context, listen: false);

          estudianteProvider.setNombresEstudiante(jsonResponse['nombres']);
          estudianteProvider.setEstudiante(jsonResponse['estudiante']);
          estudianteProvider.setPeriodo(jsonResponse['periodo']);

          final inasistenciasProvider =
              Provider.of<InasistenciasProvider>(context, listen: false);
          final dataInasistencias = jsonResponseInasistencias as List<dynamic>;
          final listaInasistencias = dataInasistencias
              .map((item) => item as Map<String, dynamic>)
              .toList();
          inasistenciasProvider.setData(listaInasistencias);
          print({'inas': inasistenciasProvider.data.length});
        }
        return jsonResponse['acceso'] == 'si';
      } // ...
      return false;
    }

    void mostrarAlert(BuildContext context, String title, String text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            key: const Key('alert'),
            title: title,
            content: text,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }

    void ingresar() async {
      setState(() {
        login = true;
      });
      bool acceso = (await fetchDataFromJson());
      setState(() {
        login = false;
      });
      if (acceso) {
        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EntradaApp()));
      } else {
        // ignore: use_build_context_synchronously
        mostrarAlert(
            context, 'Acceso Denegado', 'Estudiante o contraseña erróneas');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('NotasIE'),
          backgroundColor: const Color.fromARGB(255, 80, 137, 15),
          foregroundColor: Colors.white,
        ),
        body: Login(
            usController: usuarioController,
            passController: passwordController,
            onIngresar: ingresar,
            login: login));
  }
}
