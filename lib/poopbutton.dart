import 'dart:math';

import 'package:flutter/material.dart';

class PoopButton extends StatelessWidget {
  final Function(DateTime) onPressed;
  final random = Random();

  PoopButton(this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: const EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 75, 53, 41),
      highlightColor: Colors.brown,
      onPressed: () {
        this.onPressed(DateTime.now());
      },
      shape: CircleBorder(side: BorderSide(color: Colors.brown, width: 3)),
      elevation: 10.0,
      highlightElevation: 3.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 40.0),
        child: Text(
          '💩',
          style: TextStyle(fontSize: 100),
        ),
      ),
    );
  }
}
