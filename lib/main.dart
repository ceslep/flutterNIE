import 'package:flutter/material.dart';
import 'package:notas_ie/widgets/custom_alert.dart';

import 'widgets/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PaginaPrincipal());
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
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

  void ingresar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
              key: const Key('alerta'),
              title: 'Has Dado click',
              content: 'Boton Ingresar ${usuarioController.text}',
              actions: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Obtener Datos JSON'),
        ),
        body: Login(
          usController: usuarioController,
          passController: passwordController,
          onIngresar: ingresar,
        ));
  }
}
