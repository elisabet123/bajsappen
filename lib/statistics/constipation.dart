import 'package:bajsappen/poop.dart';
import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../pooplocalization.dart';

class ConstipationStats extends StatelessWidget {
  final Map<int, int> poopsByType;
  final TextStyle highlightStyle;
  int constipationGrade;

  ConstipationStats(List<Poop> poops, {this.highlightStyle})
      : this.poopsByType = groupByType(poops) {
    int constipatedPoops = poopsByType[0] + poopsByType[1];
    int normalPoops = poopsByType[2] + poopsByType[3];
    int diarrhoeaPoops = poopsByType[4] + poopsByType[5] + poopsByType[6];
    constipationGrade =
        constipatedPoops > normalPoops && constipatedPoops > diarrhoeaPoops
            ? 0
            : normalPoops > constipatedPoops && normalPoops > diarrhoeaPoops
                ? 1
                : 2;
  }

  static Map<int, int> groupByType(List<Poop> poops) {
    Map<int, int> poopsPerType = new Map();
    new List<int>.generate(7, (i) {
      poopsPerType[i] = 0;
      return i + 1;
    });

    poops.forEach((Poop poop) {
      if (poop.hardness != null) {
        poopsPerType[poop.hardness.floor() - 1]++;
      }
    });
    return poopsPerType;
  }

  @override
  Widget build(BuildContext context) {
    if (poopsByType.values.every((value) => value == 0)) {
      return SizedBox(
        height: 0,
      );
    }
    return Center(
        child: StatisticsCard(
      children: [
        Text(PoopLocalizations.of(context).get('constipation_text_1')),
        Text(
          PoopLocalizations.of(context)
              .get('constipation_grade_' + constipationGrade.toString()),
          style: highlightStyle,
        ),
        Text(PoopLocalizations.of(context).get('constipation_text_2')),
      ],
      onTap: () => _showDetails(context),
    ));
  }

  void _showDetails(BuildContext context) {
    List<StoolTypeSeries> data = List();
    poopsByType.forEach((key, value) => data.add(StoolTypeSeries(
          type: key.toString(),
          // PoopLocalizations.of(context).get(weekdayNames[key]).substring(0,3),
          events: value,
        )));

    List<charts.Series<StoolTypeSeries, String>> series = [
      charts.Series(
          id: "PoopEvents",
          data: data,
          domainFn: (StoolTypeSeries series, _) => series.type,
          measureFn: (StoolTypeSeries series, _) => series.events,
          colorFn: (StoolTypeSeries series, _) =>
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
                PoopLocalizations.of(context).get('constipation_chart_title'),
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
              title: Text(
                  PoopLocalizations.of(context).get('constipation_statistics')),
            ),
            body: chart,
          );
        },
      ),
    );
  }
}

class StoolTypeSeries {
  final String type;
  final int events;

  StoolTypeSeries({@required this.type, @required this.events});
}
