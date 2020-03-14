import 'package:bajsappen/poop.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllPoopPage extends StatefulWidget {
  final List<Poop> poops;
  final Function(Poop) _deletePoop;

  AllPoopPage(this.poops, this._deletePoop, {Key key}) : super(key: key) {
    this.poops.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  State<StatefulWidget> createState() => AllPoopPageState(poops, _deletePoop);
}

class AllPoopPageState extends State<AllPoopPage> {
  final Function(Poop) _deletePoop;
  List<Poop> poops;
  ScaffoldState scaffold;

  AllPoopPageState(this.poops, this._deletePoop);

  Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(PoopLocalizations.of(context).get('remove_poop_title')),
            content:
                Text(PoopLocalizations.of(context).get('remove_poop_question')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(PoopLocalizations.of(context).get('remove'))),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(PoopLocalizations.of(context).get('cancel')),
              ),
            ],
          );
        });
  }

  onDelete(BuildContext context, Poop poop) {
    _deletePoop(poop).then((_) {
      // undo?
      poops.remove(poop);
      setState(() {
        poops = poops;
      });
      scaffold.showSnackBar(SnackBar(
          content: Text(
              '${DateFormat('yyyy-MM-dd HH:mm').format(poop.dateTime)}' +
                  PoopLocalizations.of(context).get('removed'))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<Dismissible> tiles = poops.map(
      (Poop poop) {
        return Dismissible(
          key: Key(poop.dateTime.millisecondsSinceEpoch.toString()),
          onDismissed: (direction) => onDelete(context, poop),
          child: ListTile(
            title: Text(
              '${DateFormat('yyyy-MM-dd HH:mm').format(poop.dateTime)}',
            ),
            trailing: Container(
              child: Image(
                image: poop.hardness != null
                    ? AssetImage('assets/images/type-' +
                        poop.hardness.floor().toString() +
                        '.png')
                    : AssetImage('assets/images/empty.png'),
                height: 50,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 0)),
            ),
            onLongPress: () async {
              var delete = await confirmDelete(context);
              if (delete) {
                await onDelete(context, poop);
                // TODO update the dismissable list
              }
            },
          ),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (DismissDirection direction) =>
              confirmDelete(context),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(PoopLocalizations.of(context).get('all_poops')),
      ),
      body: Builder(
        builder: (BuildContext buildContext) {
          scaffold = Scaffold.of(buildContext);
          return ListView(children: divided);
        },
      ),
    );
  }
}
