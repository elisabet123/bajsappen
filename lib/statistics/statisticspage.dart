import 'package:bajsappen/statistics/count.dart';
import 'package:bajsappen/statistics/weekday.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  StatisticPage({Key key, this.poops}) : super(key: key);
  final List<DateTime> poops;

  @override
  _StatisticPageState createState() => _StatisticPageState(poops);
}

class _StatisticPageState extends State<StatisticPage> {
  final List<DateTime> _poops;
  final List<Widget> statisticsWidgets = [];
  final TextStyle highlightStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  _StatisticPageState(this._poops) {
    statisticsWidgets.add(CounterWidget(poops: _poops, highlightStyle: highlightStyle));
    statisticsWidgets.add(WeekdayStats(poops: _poops, highlightStyle: highlightStyle));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: statisticsWidgets,
    );
  }
}
