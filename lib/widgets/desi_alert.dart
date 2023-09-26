import 'package:flutter/material.dart';

class DAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  const DAlertDialog({
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
          const Icon(
            Icons.info,
            color: Colors.blue,
          ),
          Text(title),
        ],
      ),
      content: Row(
        children: [
          Text(content),
          const Icon(
            Icons.question_mark,
            color: Colors.blue,
          ),
        ],
      ),
      actions: actions,
    );
  }
}
