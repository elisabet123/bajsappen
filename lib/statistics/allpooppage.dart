import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllPoopPage {
  AllPoopPage(this.poops, this._onDismissed);

  final List<DateTime> poops;
  final Function(DateTime) _onDismissed;

  ScaffoldState scaffold;

  MaterialPageRoute getMaterialPageRoute() {
    return MaterialPageRoute<void>(
      builder: builder(),
    );
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
                scaffold
                    .showSnackBar(SnackBar(content: Text("$pooptime dismissed")));
              });
            },
            child: ListTile(
              title: Text(
                '${DateFormat('yyyy-MM-dd HH:mm').format(pooptime)}',
              ),
              onTap: () {
                print('hej');
              },
            ),
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
