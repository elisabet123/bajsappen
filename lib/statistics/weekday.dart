import 'package:bajsappen/poop.dart';
import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../pooplocalization.dart';

class WeekdayStats extends StatefulWidget {
  final Map<int, int> poopsByWeekday;
  final String mostPopularDay;
  final TextStyle highlightStyle;
  static final List<String> weekdayNames = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  WeekdayStats({Key key, List<Poop> poops, this.highlightStyle})
      : this.poopsByWeekday = groupByDay(poops),
        this.mostPopularDay = getMostPopularDay(groupByDay(poops)),
        super(key: key);

  @override
  WeekdayStatsState createState() => WeekdayStatsState(
      poopsByWeekday, mostPopularDay, weekdayNames, highlightStyle);

  static Map<int, int> groupByDay(List<Poop> poops) {
    Map<int, int> poopsPerDay = new Map();
    new List<int>.generate(7, (i) {
      poopsPerDay[i] = 0;
      return i + 1;
    });

    poops.forEach((Poop poop) => poopsPerDay[poop.dateTime.weekday - 1]++);
    return poopsPerDay;
  }

  static String getMostPopularDay(Map<int, int> dailyStats) {
    if (dailyStats.isEmpty) {
      return '';
    }

    int index = maxBy(dailyStats.entries, (entry) => entry.value).key;

    return weekdayNames[index];
  }
}

class WeekdayStatsState extends State<WeekdayStats> {
  final Map<int, int> poopsByWeekday;
  final String mostPopularDay;
  final List<String> weekdayNames;
  final TextStyle highlightStyle;

  WeekdayStatsState(this.poopsByWeekday, this.mostPopularDay, this.weekdayNames,
      this.highlightStyle);

  void _showDetails() {
    List<WeekdaySeries> data = List();
    poopsByWeekday.forEach((key, value) => data.add(WeekdaySeries(
          weekday: PoopLocalizations.of(context).get(weekdayNames[key]).substring(0,3),
          events: value,
        )));

    List<charts.Series<WeekdaySeries, String>> series = [
      charts.Series(
          id: "PoopEvents",
          data: data,
          domainFn: (WeekdaySeries series, _) => series.weekday,
          measureFn: (WeekdaySeries series, _) => series.events,
          colorFn: (WeekdaySeries series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue))
    ];

    Widget chart = Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                PoopLocalizations.of(context).get('weekday_chart_title'),
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(PoopLocalizations.of(context).get('weekday_statistics')),
            ),
            body: chart,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: StatisticsCard(
      children: [
        Text(PoopLocalizations.of(context).get('popular_poopday')),
        Text(
          PoopLocalizations.of(context).get(mostPopularDay) ?? '',
          style: highlightStyle,
        )
      ],
      onTap: _showDetails,
    ));
  }
}

class WeekdaySeries {
  final String weekday;
  final int events;

  WeekdaySeries({@required this.weekday, @required this.events});
}
