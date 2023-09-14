import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notas_ie/widgets/custom_alert.dart';
import 'package:notas_ie/widgets/entreda_app.dart';
import 'widgets/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

const String urlbase = 'https://app.iedeoccidente.com';

void main() {
  runApp(const MainApp());
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
  }

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> fetchDataFromJson() async {
    final url = Uri.parse('$urlbase/est/php/login.php');
    final bodyData = json.encode({
      'identificacion': usuarioController.text,
      'pass': passwordController.text
    });
    final response = await http.post(url, body: bodyData);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      print(jsonResponse['acceso']);

      return jsonResponse['acceso'] == 'si';
    } // ...
    return false;
  }

  void _mostrarAlert(BuildContext context, String title, String text) {
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const EntradaApp()));
    } else {
      // ignore: use_build_context_synchronously
      _mostrarAlert(
          context, 'Acceso Denegado', 'Estudiante o contraseña erróneas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NotasIE'),
          backgroundColor: const Color.fromARGB(255, 80, 137, 15),
        ),
        body: Login(
            usController: usuarioController,
            passController: passwordController,
            onIngresar: ingresar,
            login: login));
  }
}
