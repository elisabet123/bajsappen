import 'package:flutter/material.dart';
import 'package:flutter_app/statistics/weekday.dart';

class StatisticPage extends StatefulWidget {
  StatisticPage({Key key, this.poops}) : super(key: key);
  final List<DateTime> poops;

  @override
  _StatisticPageState createState() => _StatisticPageState(poops);
}

class _StatisticPageState extends State<StatisticPage> {
  final List<DateTime> _poops;
  final List<Widget> statisticsWidgets = [];

  _StatisticPageState(this._poops) {
    statisticsWidgets.add(WeekdayStats(poops: _poops));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: statisticsWidgets,
    );
  }
}
