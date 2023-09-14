import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final VoidCallback onIngresar;
  final TextEditingController usController;
  final TextEditingController passController;
  const Login(
      {Key? key,
      required this.usController,
      required this.passController,
      required this.onIngresar})
      : super(key: key);
  // ignore: library_private_types_in_public_api
  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(35),
          child: TextField(
            controller: widget.usController,
            decoration: const InputDecoration(
              labelText: "Usuario",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(35),
          child: TextField(
            controller: widget.passController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Contraseña",
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Botón Registrarse
                ElevatedButton(
                  onPressed: () {
                    // Haz algo cuando el botón Registrarse se presione.
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amberAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("Registrar"), Icon(Icons.person_add)]),
                ),
                const SizedBox(width: 20),
                // Botón Cancelar
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: widget.onIngresar,
                  child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text("Ingresar"), Icon(Icons.login)]),
                ),
              ],
            )),
      ],
    );
  }
}
