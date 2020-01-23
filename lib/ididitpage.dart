import 'package:bajsappen/poopbutton.dart';
import 'package:flutter/material.dart';

class IDidItPage extends StatefulWidget {
  IDidItPage({Key key, this.lastPoop, this.onPressed}) : super(key: key);
  final DateTime lastPoop;
  final Function(DateTime) onPressed;

  @override
  _IDidItPageState createState() => _IDidItPageState(lastPoop, onPressed);
}

class _IDidItPageState extends State<IDidItPage> {
  _IDidItPageState(this._lastPoop, this.onPressed);

  DateTime _lastPoop;
  final Function(DateTime) onPressed;

  void _pooped(DateTime poopTime) {
    onPressed(poopTime);
    this.setState(() {
      this._lastPoop = poopTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PoopButton(_pooped),
          SizedBox(height: 25.0,),
          Text(
            'Last time you pooped:',
          ),
          Text(
            _lastPoop != null ? '$_lastPoop' : '',
          ),
        ],
      ),
    );
  }
}
