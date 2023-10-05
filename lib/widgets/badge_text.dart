import 'package:flutter/material.dart';
import 'dart:async';

class BadgeText extends StatefulWidget {
  final String text;
  final String badgeText;
  final TextStyle style;
  final Color color;

  const BadgeText(
      {super.key,
      required this.text,
      required this.badgeText,
      required this.style,
      required this.color});

  @override
  State<BadgeText> createState() => _BadgeTextState();
}

class _BadgeTextState extends State<BadgeText> {
  bool _isVisible = true;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      _isVisible = !_isVisible; // Cambia la visibilidad del texto
      if (mounted) {
        super.setState(
          () {},
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Row(
          children: [
            Text('${widget.text}  ', style: widget.style),
          ],
        ),
        if (widget.badgeText.isNotEmpty)
          Positioned(
              width: 15,
              height: 15,
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity:
                    widget.badgeText.isNotEmpty ? (_isVisible ? 1.0 : 0.0) : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 10),
                ),
              )),
      ],
    );
  }
}
