import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../poop.dart';

class PoopButtonAddDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PoopButtonAddDialogState();
  }
}

class PoopButtonAddDialogState extends State<PoopButtonAddDialog> {
  DateTime _poop = DateTime.now();
  double hardness = 1;
  bool hardnessChanged = false;

  bool typeSelectorOpen = false;

  DateTime setTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime setDate(DateTime date, DateTime original) {
    return DateTime(
        date.year, date.month, date.day, original.hour, original.minute);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _poop,
      firstDate: DateTime(_poop.year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _poop = setDate(picked, _poop);
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_poop),
    );

    setState(() {
      _poop = setTime(_poop, time);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);

    return Dialog(
        child: Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DefaultTextStyle(
            style: dialogTheme.titleTextStyle ?? theme.textTheme.title,
            child: Semantics(
              child: Text(PoopLocalizations.of(context).get('add_poop_title')),
              namesRoute: true,
              container: true,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: Text(
                  '${DateFormat('yyyy-MM-dd').format(_poop)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () => _selectDate(context),
              ),
              FlatButton(
                padding: EdgeInsets.fromLTRB(30, 10.0, 30.0, 10.0),
                child: Text(
                  '${DateFormat('HH:mm').format(_poop)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            height: 50,
          ),
          FlatButton(
              padding: EdgeInsets.all(10),
              onPressed: () async {
                setState(() {
                  typeSelectorOpen = !typeSelectorOpen;
                });
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.black54,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('hårdhet'),
                      Icon(typeSelectorOpen
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_left),
                    ],
                  ),
                  SizedBox(
                    height: typeSelectorOpen ? 10 : 0,
                  ),
                  typeSelectorOpen
                      ? Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Image(
                                    image: hardnessChanged
                                        ? AssetImage('assets/images/type-' +
                                            hardness.floor().toString() +
                                            '.png')
                                        : AssetImage('assets/images/empty.png'),
                                    height: 50,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 0)),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        showValueIndicator:
                                            ShowValueIndicator.never,
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 15),
                                      ),
                                      child: Slider(
                                        value: hardness,
                                        min: 1,
                                        max: 7.99,
                                        divisions: 70,
                                        onChanged: (double newValue) {
                                          setState(() {
                                            hardness = newValue;
                                            hardnessChanged = true;
                                          });
                                        },
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(PoopLocalizations.of(context).get('type_' +
                                hardness.floor().toString() +
                                '_description'))
                          ],
                        )
                      : SizedBox(
                          height: 0,
                        )
                ],
              )),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(PoopLocalizations.of(context).get('cancel')),
              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(Poop(_poop, hardness)),
                  child: Text(PoopLocalizations.of(context).get('add'))),
            ],
          ),
        ],
      ),
    ));
  }
}
