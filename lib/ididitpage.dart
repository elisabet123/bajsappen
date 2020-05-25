import 'package:bajsappen/poop.dart';
import 'package:bajsappen/poopbutton.dart';
import 'package:bajsappen/pooplocalization.dart';
import 'package:bajsappen/pooppagestate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'database_helpers.dart';

class IDidItPage extends StatefulWidget {
  @override
  IDidItPageState createState() {
    return IDidItPageState();
  }
}

class IDidItPageState extends PoopPageState {
  Poop _lastPoop;

  @override
  refresh() async {
    var poops = await super.getAllPoops();
    setState(() {
      _lastPoop = poops.isNotEmpty ? poops.first : null;
    });
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