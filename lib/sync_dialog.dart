import 'package:bajsappen/pooppagestate.dart';
import 'package:flutter/material.dart';

class Syncer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SyncState();
}

class SyncState extends PoopPageState {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          _showInputDialog(context);
        });

  }

  @override
  void refresh() {
    // TODO: implement refresh
  }

  _showInputDialog(BuildContext context) async {
    String currentCode = await this.getPersonalCode();
    String personalCode = await showDialog(
      context: context,
      child: new SyncDialog(currentCode),
    );
    if (personalCode != null) {
      this.setPersonalCode(personalCode);
      this.refresh();
    }
  }
}

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
