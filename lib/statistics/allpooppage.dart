import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllPoopPage {
  AllPoopPage(this.poops, this._onDismissed) {
    this.poops.sort((a, b) => b.compareTo(a));
  }

  final List<DateTime> poops;
  final Function(DateTime) _onDismissed;

  ScaffoldState scaffold;

  MaterialPageRoute getMaterialPageRoute() {
    return MaterialPageRoute<void>(
      builder: builder(),
    );
  }

  Future<bool> confirmDismiss(
      DismissDirection direction, BuildContext context) async {
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

  WidgetBuilder builder() {
    return (BuildContext context) {
      final Iterable<Dismissible> tiles = poops.map(
        (DateTime pooptime) {
          return Dismissible(
            key: Key(pooptime.millisecondsSinceEpoch.toString()),
            onDismissed: (direction) {
              _onDismissed(pooptime).then((_) {
                // undo?
                scaffold.showSnackBar(SnackBar(
                    content: Text(
                        '${DateFormat('yyyy-MM-dd HH:mm').format(pooptime)}' +
                            PoopLocalizations.of(context).get('removed'))));
              });
            },
            child: ListTile(
              title: Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(pooptime)}',
              ),
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
                confirmDismiss(direction, context),
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
    };
  }
}
