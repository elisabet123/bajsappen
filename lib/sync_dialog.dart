import 'package:flutter/material.dart';

class SyncDialog extends StatelessWidget {
  final String personalCode;

  const SyncDialog(this.personalCode, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String personalCode = this.personalCode == null ? '' : this.personalCode;
    TextEditingController _c = new TextEditingController(text: personalCode);
    return new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      title: new Text('Synka mellan enheter'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text('För att kunna synca från en annan enhet, ange dess personliga kod här.'),
          new Row(
            children: [
              new Text('Din personliga kod är: '),
              new Text(personalCode, style: new TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
          new TextField(
              autofocus: true,
              decoration: new InputDecoration(labelText: 'Ange kod'),
              controller: _c,
            ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: const Text('AVBRYT'),
            onPressed: () {
              Navigator.of(context).pop(null);
            }),
        new FlatButton(
            child: const Text('SPARA'),
            onPressed: () {
              Navigator.of(context).pop(_c.text);
            })
      ],
    );
  }

}
