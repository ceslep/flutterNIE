import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const CustomAlertDialog({
    required Key key,
    required this.title,
    required this.content,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(title),
          const Icon(
            Icons.person,
            color: Colors.blue,
          ),
        ],
      ),
      content: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.red,
          ),
          Text(content),
        ],
      ),
      actions: actions,
    );
  }
}
