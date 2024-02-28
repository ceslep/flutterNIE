import 'package:flutter/material.dart';
import 'dart:async';

/* void errorInternet(BuildContext context, String titulo, String contenido) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () => Navigator.of(context).pop("volver"),
          ),
        ],
      );
    },
  );
}
 */

Future<String> errorInternet(
    BuildContext context, String titulo, String contenido) async {
  Completer<String> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              completer.complete("volver");
              Navigator.of(context).pop("volver");
            },
          ),
        ],
      );
    },
  );

  return completer.future;
}
