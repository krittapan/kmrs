// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class TextColumnWidget extends StatelessWidget {
  TextColumnWidget({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TextRowWidget extends StatelessWidget {
  TextRowWidget({Key? key, required this.text}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    var finaltext = '';
    final textlen = text.length;
    finaltext = textlen < 150 ? text : '${text.substring(0, 100)}...';
    return Text(finaltext,
        textAlign: finaltext.toString() == 'null' || finaltext.toString() == '-'
            ? TextAlign.center
            : null);
  }
}