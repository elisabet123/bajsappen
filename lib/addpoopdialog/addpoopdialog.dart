import 'package:bajsappen/addpoopdialog/datetimebuttons.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../poop.dart';

class PoopButtonAddDialog extends StatefulWidget {
  @override
  PoopButtonAddDialogState createState() => PoopButtonAddDialogState();
}

class PoopButtonAddDialogState extends State<PoopButtonAddDialog> {
  DateTime _poopDateTime = DateTime.now();
  double hardness = 4;

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
      initialDate: _poopDateTime,
      firstDate: DateTime(_poopDateTime.year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _poopDateTime = setDate(picked, _poopDateTime);
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_poopDateTime),
    );

    setState(() {
      _poopDateTime = setTime(_poopDateTime, time);
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
            height: 25,
          ),
          DateTimeButtons(_poopDateTime, _selectDate, _selectTime),
          Divider(
            thickness: 1,
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: FlatButton(
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
                        Text(PoopLocalizations.of(context)
                            .get('poop_input_hardness')),
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
                              SliderTheme(
                                data: SliderThemeData(
                                  showValueIndicator: ShowValueIndicator.never,
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 15),
                                ),
                                child: Slider(
                                  value: hardness,
                                  min: 1,
                                  max: 7,
                                  divisions: 6,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      hardness = newValue;
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                   Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(3),
                              child: Image(
                                        image: AssetImage(
                                            'assets/images/type-' +
                                                hardness.floor().toString() +
                                                '.png'),
                                        height: 50,
                                      )),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(width: 0)),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(PoopLocalizations.of(context)
                                        .get('type_' +
                                            hardness.floor().toString() +
                                            '_description')),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 0,
                          )
                  ],
                )),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(PoopLocalizations.of(context).get('cancel')),
              ),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(
                      Poop(_poopDateTime, typeSelectorOpen ? hardness : null)),
                  child: Text(PoopLocalizations.of(context).get('add'))),
            ],
          ),
        ],
      ),
    ));
  }
}
