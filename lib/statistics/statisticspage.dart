import 'package:bajsappen/statistics/count.dart';
import 'package:bajsappen/statistics/weekday.dart';
import 'package:flutter/material.dart';

import '../database_helpers.dart';

class StatisticPage extends StatefulWidget {
  StatisticPage(this._onPoopDeleted, {Key key}) : super(key: key);
  final Function(DateTime) _onPoopDeleted;

  @override
  _StatisticPageState createState() => _StatisticPageState(_onPoopDeleted);
}

class _StatisticPageState extends State<StatisticPage> {
  List<Widget> statisticsWidgets = [];
  final Function(DateTime) _onPoopDeleted;
  final TextStyle highlightStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  void onPoopDeleted(DateTime poop) async {
    await _onPoopDeleted(poop);
    await _refresh();
  }

  _refresh() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<DateTime> poops = await helper.getAllPoops() ?? [];

    List<Widget> refreshedWidgets = [];
    refreshedWidgets.add(
        CounterWidget(poops, highlightStyle, onPoopDeleted,));
    refreshedWidgets.add(
        WeekdayStats(poops: poops, highlightStyle: highlightStyle));
    statisticsWidgets = refreshedWidgets;
  }

  _StatisticPageState(this._onPoopDeleted) {
    _refresh().then((poops) {
      setState(() {
        statisticsWidgets = statisticsWidgets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: statisticsWidgets,
    );
  }
}
