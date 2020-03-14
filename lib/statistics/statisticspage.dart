import 'package:bajsappen/statistics/constipation.dart';
import 'package:bajsappen/statistics/count.dart';
import 'package:bajsappen/statistics/timeofday.dart';
import 'package:bajsappen/statistics/weekday.dart';
import 'package:flutter/material.dart';

import '../database_helpers.dart';
import '../poop.dart';

class StatisticPage extends StatefulWidget {
  StatisticPage({Key key}) : super(key: key);

  @override
  StatisticPageState createState() => StatisticPageState();
}

class StatisticPageState extends State<StatisticPage> {
  List<Widget> statisticsWidgets = [];
  DatabaseHelper helper = DatabaseHelper.instance;
  final TextStyle highlightStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  void onPoopDeleted(Poop poop) async {
    await helper.delete(poop);
    await refresh();
  }

  refresh() async {
    List<Poop> poops = await helper.getAllPoops() ?? [];

    List<Widget> refreshedWidgets = [];
    refreshedWidgets.add(CounterWidget(
      poops,
      highlightStyle,
      onPoopDeleted,
    ));
    refreshedWidgets
        .add(WeekdayStats(poops: poops, highlightStyle: highlightStyle));
    refreshedWidgets.add(TimeOfDayStats(poops, highlightStyle: highlightStyle));
    refreshedWidgets.add(ConstipationStats(poops: poops, highlightStyle: highlightStyle));
    statisticsWidgets = refreshedWidgets;
  }

  StatisticPageState() {
    refresh().then((poops) {
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
