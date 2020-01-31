import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PoopButton extends StatefulWidget {
  final Function(DateTime) onPressed;

  PoopButton(this.onPressed) : super();

  @override
  State<StatefulWidget> createState() {
    return PoopButtonState(onPressed);
  }
}

class PoopButtonState extends State<PoopButton> {
  final Function(DateTime) onPressed;

  PoopButtonState(this.onPressed) : super();

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      padding: const EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 75, 53, 41),
      highlightColor: Colors.brown,
      onPressed: () async {
        var poop = await showDialog(
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

class PoopButtonAddDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PoopButtonAddDialogState();
  }
}

class PoopButtonAddDialogState extends State<PoopButtonAddDialog> {
  DateTime _poop = DateTime.now();

  DateTime setMidnightTime(DateTime initial) {
    return DateTime(initial.year, initial.month, initial.day);
  }

  DateTime setTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _poop,
      firstDate: DateTime(_poop.year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != setMidnightTime(_poop)) {
      final TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_poop),
      );

      setState(() {
        _poop = setTime(picked, time);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);

    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0), //last one 0.0?
            child: DefaultTextStyle(
              style: dialogTheme.titleTextStyle ?? theme.textTheme.title,
              child: Semantics(
                child: Text(PoopLocalizations.of(context).get('add_poop_title')),
                namesRoute: true,
                container: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('${DateFormat('yyyy-MM-dd HH:mm').format(_poop)}'),
              RaisedButton(
                onPressed: () => _selectDate(context),
                child: Text(PoopLocalizations.of(context).get('change_date')),
              ),
            ],
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(PoopLocalizations.of(context).get('cancel')),
              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(_poop),
                  child: Text(PoopLocalizations.of(context).get('add'))
              ),
            ],
          ),
        ],
      ),
    );

  }
}

/*
return AlertDialog(
      title: Text(PoopLocalizations.of(context).get('add_poop_title')),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${DateFormat('yyyy-MM-dd HH:mm').format(_poop)}'),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text(PoopLocalizations.of(context).get('change_date')),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(PoopLocalizations.of(context).get('cancel')),
        ),
        FlatButton(
            onPressed: () => Navigator.of(context).pop(_poop),
            child: Text(PoopLocalizations.of(context).get('add'))),
      ],
    );
 */
