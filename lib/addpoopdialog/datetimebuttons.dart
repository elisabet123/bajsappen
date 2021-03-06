import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeButtons extends StatelessWidget {
  final DateTime _poop;
  final Function(BuildContext) _selectDate;
  final Function(BuildContext) _selectTime;

  const DateTimeButtons(this._poop, this._selectDate, this._selectTime,
      {Key key})
      : super(key: key);

  FlatButton _button(String text, EdgeInsets padding, Function() _onPressed) {
    return FlatButton(
      padding: padding,
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, color: Colors.black54),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: _onPressed,
    );
  }

  FlatButton _dateButton(BuildContext context) {
    return _button(
      '${DateFormat('yyyy-MM-dd').format(_poop)}',
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      () => _selectDate(context),
    );
  }

  FlatButton _timeButton(BuildContext context) {
    return _button(
      '${DateFormat('HH:mm').format(_poop)}',
      EdgeInsets.only(left: 31, right: 31, top: 10, bottom: 10),
      () => _selectTime(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      layoutBehavior: ButtonBarLayoutBehavior.constrained,
      children: <Widget>[
        _dateButton(context),
        _timeButton(context),
      ],
    );
  }
}
