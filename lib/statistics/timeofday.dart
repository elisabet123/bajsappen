import 'package:bajsappen/poop.dart';
import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../pooplocalization.dart';

class TimeOfDayStats extends StatelessWidget {
  final TextStyle highlightStyle;
  final List<Poop> poops;
  final Map<int, int> poopsPerHour;
  final Map<int, int> poopsPerTimeOfDay;
  final List<String> timeOfDayStrings = [
    'night',
    'morning',
    'afternoon',
    'evening'
  ];

  TimeOfDayStats(this.poops, {Key key, this.highlightStyle})
      : this.poopsPerHour = _groupByHour(poops),
        this.poopsPerTimeOfDay = new Map() {
    _groupByTimeOfDay();
  }

  static Map<int, int> _groupByHour(List<Poop> poops) {
    Map<int, int> poopsPerHour = new Map();
    new List<int>.generate(24, (i) {
      poopsPerHour[i] = 0;
      return i + 1;
    });

    poops.forEach((Poop poop) => poopsPerHour[poop.dateTime.hour]++);
    return poopsPerHour;
  }

  _groupByTimeOfDay() {
    new List<int>.generate(4, (i) {
      poopsPerTimeOfDay[i] = _countPoopsWithinHours(poopsPerHour, 6 * i, 6 * (i + 1));
      return i + 1;
    });
  }

  int _countPoopsWithinHours(Map<int, int> input, int minHour, int maxHour) {
    return input.entries
        .where((entry) => entry.key < maxHour && entry.key >= minHour)
        .toList()
        .map((MapEntry entry) => entry.value)
        .reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    if (poops.isEmpty) {
      return SizedBox(
        height: 0,
      );
    }
    String popularTime = poopsPerTimeOfDay.values.every((poops) => poops == 0)
        ? ''
        : PoopLocalizations.of(context).get('the_' +
                timeOfDayStrings[
                    maxBy(poopsPerTimeOfDay.entries, (entry) => entry.value)
                        .key]) ??
            '';
    return Center(
        child: StatisticsCard(
      children: [
        Text(PoopLocalizations.of(context).get('popular_pooptime')),
        Text(
          popularTime,
          style: highlightStyle,
        )
      ],
      onTap: () => _showDetails(context),
    ));
  }

  void _showDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(PoopLocalizations.of(context).get('time_statistics')),
            ),
            body: ChartPage(poopsPerHour, poopsPerTimeOfDay, timeOfDayStrings),
          );
        },
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  final Map<int, int> poopsPerHour;
  final Map<int, int> poopsPerTimeOfDay;
  final List<String> timeOfDayStrings;

  const ChartPage(
      this.poopsPerHour, this.poopsPerTimeOfDay, this.timeOfDayStrings,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = poopsPerHour
        .map((key, value) =>
            MapEntry(key, PoopsPerHourSeries(DateTime(2020, 1, 2, key), value)))
        .values
        .toList();
    List<charts.Series<PoopsPerHourSeries, DateTime>> otherSeries = [
      new charts.Series<PoopsPerHourSeries, DateTime>(
        id: 'PoopsPerHour',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (PoopsPerHourSeries poops, _) => poops.dateTime,
        measureFn: (PoopsPerHourSeries poops, _) => poops.poops,
        data: data,
      )
    ];
    Widget hourChart = createChart(
        'poops_per_hour',
        charts.TimeSeriesChart(
          otherSeries,
          animate: true,
          defaultRenderer: new charts.BarRendererConfig<DateTime>(),
          defaultInteractions: false,
          domainAxis: new charts.DateTimeAxisSpec(
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
              hour: new charts.TimeFormatterSpec(
                format: 'HH',
                transitionFormat: 'HH',
              ),
            ),
          ),
        ),
        context);

    List<charts.Series<MapEntry<int, int>, String>> timeOfDaySeries = [
      charts.Series(
          id: "PoopsTimeOfDay",
          data: poopsPerTimeOfDay.entries.toList(),
          domainFn: (entry, _) =>
              PoopLocalizations.of(context).get(timeOfDayStrings[entry.key]),
          measureFn: (entry, _) => entry.value,
          colorFn: (entry, _) => charts.ColorUtil.fromDartColor(Colors.blue))
    ];

    Widget timeOfDayChart = createChart('poops_per_time_of_day',
        charts.BarChart(timeOfDaySeries, animate: true), context);

    return ListView(
        children: <Widget>[hourChart, timeOfDayChart],
      );
  }

  Widget createChart(String titleKey, Widget chart, BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                PoopLocalizations.of(context).get(titleKey),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: chart,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PoopsPerHourSeries {
  final DateTime dateTime;
  final int poops;

  PoopsPerHourSeries(this.dateTime, this.poops);
}
