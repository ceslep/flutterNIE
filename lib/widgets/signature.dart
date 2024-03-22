// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:com_celesoft_notasieo/widgets/confirm_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'dart:typed_data';
import 'dart:convert';

final DrawingController _drawingController = DrawingController();

class Signature extends StatefulWidget {
  const Signature({super.key});

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  String imageToBase64(Uint8List imageBytes) {
    // Convierte los bytes de la imagen a una cadena Base64
    return base64Encode(imageBytes);
  }

  Future<String> _getImageData() async {
    final directory = await getApplicationDocumentsDirectory();
    Uint8List imageData =
        (await _drawingController.getImageData())!.buffer.asUint8List();
    final file = File('${directory.path}/firma.png');
    await file.writeAsBytes(imageData);
    String base64String = imageToBase64(imageData);
    return base64String;
  }

  @override
  void initState() {
    super.initState();
    _drawingController.clear();
    _drawingController.setStyle(
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Firmar'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
              onPressed: () async {
                _showConfirmationDialog(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.save,
                color: Colors.yellow,
              ),
              onPressed: () async {
                String firma = await _getImageData();

                if (mounted) {
                  Navigator.pop(context, {"firma": firma});
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DrawingBoard(
                controller: _drawingController,
                background: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 0.75 * MediaQuery.of(context).size.height,
                    color: Colors.white),
                showDefaultActions: false,
                showDefaultTools: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmDialog(
          title: 'Borrar pantalla de firma',
          content: 'Desea borrar la firma creada?',
          cancelText: 'Cancelar',
          confirmText: 'Confirma',
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        // Se confirmó la acción
        // Aquí puedes realizar la acción que desees después de confirmar
        _drawingController.clear();
        print('Action confirmed');
      } else {
        // Se canceló la acción
        print('Action canceled');
      }
    });
  }
}
