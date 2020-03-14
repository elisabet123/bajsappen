import 'package:bajsappen/poop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'addpoopdialog/addpoopdialog.dart';

class PoopButton extends StatefulWidget {
  final Function(Poop) onPressed;

  PoopButton(this.onPressed) : super();

  @override
  State<StatefulWidget> createState() {
    return PoopButtonState(onPressed);
  }
}

class PoopButtonState extends State<PoopButton> {
  final Function(Poop) onPressed;

  PoopButtonState(this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: const EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 75, 53, 41),
      highlightColor: Colors.brown,
      onPressed: () async {
        Poop poop = await showDialog(
            context: context,
            builder: (_) {
              return PoopButtonAddDialog();
            });

        if (poop != null) {
          this.onPressed(poop);
        }
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
