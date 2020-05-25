import 'package:bajsappen/poop.dart';
import 'package:bajsappen/poopbutton.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helpers.dart';

class IDidItPage extends StatefulWidget {
  @override
  IDidItPageState createState() {
    return IDidItPageState();
  }
}

class IDidItPageState extends State<IDidItPage> {
  Poop _lastPoop;
  DatabaseHelper helper = DatabaseHelper.instance;

  IDidItPageState() {
    refresh();
  }

  @override
  void didUpdateWidget(IDidItPage oldVariant) {
    refresh();
    super.didUpdateWidget(oldVariant);
  }

  refresh() async {
    var poops = await helper.getAllPoops();
    setState(() {
      _lastPoop = poops.isNotEmpty ? poops.first : null;
    });
  }

  void addPoop(Poop poop) {
    helper.insertPoop(poop);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PoopButton(addPoop),
          SizedBox(height: 25.0,),
          Text(PoopLocalizations.of(context).get('latest_poop')),
          Text(
            _lastPoop != null ? '${DateFormat('yyyy-MM-dd HH:mm').format(_lastPoop.dateTime)}' : '',
          ),
        ],
      ),
    );
  }
}