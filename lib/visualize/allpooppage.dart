import 'package:bajsappen/visualize/poopratingicon.dart';
import 'package:bajsappen/visualize/pooptypeimage.dart';
import 'package:bajsappen/poop.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:bajsappen/pooppagestate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllPoopPage extends StatefulWidget {
  final int cutoffTime;

  const AllPoopPage(this.cutoffTime, {Key key}) : super(key: key);

  @override
  AllPoopPageState createState() => AllPoopPageState(cutoffTime);
}

class AllPoopPageState extends PoopPageState {
  final int cutoffTime;
  List<Poop> _poops = [];
  ScaffoldState scaffold;

  AllPoopPageState(this.cutoffTime) : super();

  void refresh() async {
    var poops = await super.getAllPoops(cutoffTime);
    setState(() {
      _poops = poops;
    });
  }

  void reload() async {
    await super.syncRemote();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AllPoopWidget(_poops, super.deletePoop, reload);
  }
}

class AllPoopWidget extends StatefulWidget {
  final List<Poop> poops;
  final Function(Poop) _deletePoop;
  final Function _reload;

  AllPoopWidget(this.poops, this._deletePoop, this._reload, {Key key}) : super(key: key);

  @override
  AllPoopWidgetState createState() =>
      AllPoopWidgetState(this.poops, _deletePoop, _reload);
}

class AllPoopWidgetState extends State<AllPoopWidget> {
  final Function(Poop) _deletePoop;
  final Function _reload;
  List<Poop> poops;
  ScaffoldState scaffold;
  bool reloadDisabled = false;

  AllPoopWidgetState(this.poops, this._deletePoop, this._reload);

  @override
  void didUpdateWidget(Widget oldVariant) {
    setState(() {
      poops = widget.poops;
    });
    super.didUpdateWidget(oldVariant);
  }

  reload() async {
    setState(() {
      reloadDisabled = true;
    });
    await _reload();
    setState(() {
      reloadDisabled = false;
    });
  }

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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PoopRatingIcon(poop),
                PoopTypeImage(poop),
              ],
            ),
            onLongPress: () async {
              var delete = await confirmDelete(context);
              if (delete) {
                await onDelete(context, poop);
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
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: reloadDisabled ? null : reload, )],
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
