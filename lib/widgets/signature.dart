import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

final DrawingController _drawingController = DrawingController();

class Signature extends StatefulWidget {
  const Signature({super.key});

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  Future<void> _getImageData() async {
    _drawingController.getImageData();
    print((await _drawingController.getImageData())?.buffer.asInt8List());
  }

  @override
  void initState() {
    super.initState();
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
                Icons.save,
                color: Colors.yellow,
              ),
              onPressed: () async {
                await _getImageData();
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
                showDefaultActions: true,
                showDefaultTools: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
