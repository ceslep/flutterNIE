import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomFooter extends StatefulWidget {
  final Text info;
  final Text extInfo;
  final Text textInfo;
  final Text valor;
  final Gradient gradiente;
  const CustomFooter(
      {super.key,
      required this.info,
      required this.extInfo,
      required this.textInfo,
      required this.valor,
      required this.gradiente});

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 232, 255, 206),
            border: Border.all(color: Colors.black),
            gradient: widget.gradiente),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "https://app.iedeoccidente.com/escudoNuevo2.png",
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: widget.info,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: widget.extInfo,
                ),
              ],
            ),
            const SizedBox(width: 6),
            widget.textInfo,
            Padding(
              padding: const EdgeInsets.only(left: 38, right: 2),
              child: Align(
                alignment: Alignment.centerRight,
                child: widget.valor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
