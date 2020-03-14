import 'package:bajsappen/poop.dart';
import 'package:bajsappen/poopbutton.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IDidItPage extends StatelessWidget {
  IDidItPage(this._lastPoop, this.onPressed, {Key key}) : super(key: key);
  final Poop _lastPoop;
  final Function(Poop) onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PoopButton(onPressed),
          SizedBox(height: 25.0,),
          Text(PoopLocalizations.of(context).get('latest_poop')),
          Text(
            _lastPoop != null ? '${DateFormat('yyyy-MM-dd HH:mm').format(_lastPoop.dateTime)}' : '',
          ),
        ],
      ),
    );
  }
}
