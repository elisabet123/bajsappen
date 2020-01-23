import 'package:charts_flutter/flutter.dart' as charts;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class WeekdayStats extends StatefulWidget {
  final Map<int, int> poopsByWeekday;
  final String mostPopularDay;
  static final List<String> weekdayNames = [
    'Måndag',
    'Tisdag',
    'Onsdag',
    'Torsdag',
    'Fredag',
    'Lördag',
    'Söndag'
  ];

  WeekdayStats({Key key, List<DateTime> poops})
      : this.poopsByWeekday = groupByDay(poops),
        this.mostPopularDay = getMostPopularDay(groupByDay(poops)),
        super(key: key);

  @override
  WeekdayStatsState createState() =>
      WeekdayStatsState(poopsByWeekday, mostPopularDay, weekdayNames);

  static Map<int, int> groupByDay(List<DateTime> poops) {
    Map<int, List<DateTime>> days =
        groupBy(poops, (datetime) => datetime.weekday);

    // I could not find a sortBy method for maps
    var dataUnSorted = days.map((key, value) => MapEntry(key, value.length));
    Map<int, int> dataSorted = Map();
    var keysSorted = dataUnSorted.keys.toList()..sort();
    keysSorted.forEach((index) => dataSorted[index] = dataUnSorted[index]);

    return dataSorted;
  }

  static String getMostPopularDay(Map<int, int> dailyStats) {
    if (dailyStats.isEmpty) {
      return '';
    }

    int index = maxBy(dailyStats.entries, (entry) => entry.value).key;

    return weekdayNames[index - 1];
  }
}

class WeekdayStatsState extends State<WeekdayStats> {
  final Map<int, int> poopsByWeekday;
  final String mostPopularDay;
  final List<String> weekdayNames;

  WeekdayStatsState(
      this.poopsByWeekday, this.mostPopularDay, this.weekdayNames);

  void _showDetails() {
    List<WeekdaySeries> data = List();
    poopsByWeekday.forEach((key, value) => data.add(WeekdaySeries(
        weekday: weekdayNames[key - 1],
        events: value,
    )));

    List<charts.Series<WeekdaySeries, String>> series = [
      charts.Series(
          id: "PoopEvents",
          data: data,
          domainFn: (WeekdaySeries series, _) => series.weekday,
          measureFn: (WeekdaySeries series, _) => series.events,
          colorFn: (WeekdaySeries series, _) => charts.ColorUtil.fromDartColor(Colors.blue)
      )
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
                "Totalt antal bajsningar per dag",
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
              title: Text('Weekday breakdown'),
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
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: _showDetails,
          child: Container(
            width: 300,
            height: 100,
            child: Center(
                child: Text('Din populäraste bajsardag: $mostPopularDay')),
          ),
        ),
      ),
    );
  }
}

class WeekdaySeries {
  final String weekday;
  final int events;

  WeekdaySeries(
      {@required this.weekday, @required this.events});
}
