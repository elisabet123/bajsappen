import 'package:flutter/material.dart';

class PoopButton extends StatelessWidget {
  final Function(DateTime) onPressed;

  const PoopButton(this.onPressed): super();

  @override
  Widget build(BuildContext context) {
    return
      Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.brown[900], width: 5.0),
          color: Colors.brown[500],
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          onTap: () {
            this.onPressed(DateTime.now());
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 40.0),
            child: Text(
              '💩',
              style: TextStyle(fontSize: 100),
            ),
          ),
        ),
      );
  }
}
