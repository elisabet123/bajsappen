import 'dart:math';

import 'package:bajsappen/poop.dart';
import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pooplocalization.dart';

class ConstipationStats extends StatelessWidget {
  final List<int> poopsByType;
  final TextStyle highlightStyle;
  List<int> poopsByGrade;

  ConstipationStats(List<Poop> poops, {this.highlightStyle})
      : this.poopsByType = groupByType(poops) {
    int constipatedPoops = poopsByType[0] + poopsByType[1];
    int normalPoops = poopsByType[2] + poopsByType[3];
    int diarrhoeaPoops = poopsByType[4] + poopsByType[5] + poopsByType[6];
    poopsByGrade = [constipatedPoops, normalPoops, diarrhoeaPoops];
  }

  static List<int> groupByType(List<Poop> poops) {
    List<int> poopsPerType = List.filled(7, 0);

    poops.forEach((Poop poop) {
      if (poop.hardness != null) {
        poopsPerType[poop.hardness.floor() - 1]++;
      }
    });
    return poopsPerType;
  }

  @override
  Widget build(BuildContext context) {
    if (poopsByType.every((value) => value == 0)) {
      return SizedBox(
        height: 0,
      );
    }
    return Center(
        child: StatisticsCard(
      children: [
        Text(PoopLocalizations.of(context).get('constipation_text_1')),
        Text(
          PoopLocalizations.of(context).get('constipation_grade_' +
              poopsByGrade.indexOf(poopsByGrade.fold(0, max)).toString()),
          style: highlightStyle,
        ),
        Text(PoopLocalizations.of(context).get('constipation_text_2')),
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
              title: Text(
                  PoopLocalizations.of(context).get('constipation_statistics')),
            ),
            body: ChartPage(poopsByType, poopsByGrade),
          );
        },
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  final List<int> poopsPerType;
  final List<int> poopsPerGrade;

  const ChartPage(this.poopsPerType, this.poopsPerGrade, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = poopsPerType
        .asMap()
        .map((key, value) =>
            MapEntry(key, StoolTypeSeries(type: (key + 1).toString(), events: value)))
        .values
        .toList();
    List<charts.Series<StoolTypeSeries, String>> series = [
      new charts.Series<StoolTypeSeries, String>(
        id: 'PoopsPerType',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StoolTypeSeries poops, _) => poops.type,
        measureFn: (StoolTypeSeries poops, _) => poops.events,
        data: data,
      )
    ];
    Widget typeChartSection = createChartSection('constipation_chart_type_title',
        charts.BarChart(series, animate: true), context, 2);

    List<charts.Series<MapEntry<int, int>, String>> constipationGradeSeries = [
      charts.Series(
          id: "constipationGrade",
          data: poopsPerGrade.asMap().entries.toList(),
          domainFn: (entry, _) => PoopLocalizations.of(context)
              .get('constipation_grade_' + entry.key.toString()),
          measureFn: (entry, _) => entry.value,
          colorFn: (entry, _) => charts.ColorUtil.fromDartColor(Colors.blue))
    ];

    Widget gradeChart = Column(
      children: <Widget>[
        Expanded(
            child: charts.BarChart(constipationGradeSeries, animate: true)),
        Padding(
          padding: EdgeInsets.all(8),
          child:         Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              typeExplanation(context, 1, 2, 0),
              typeExplanation(context, 3, 4, 1),
              typeExplanation(context, 5, 7, 2),
            ],
          )
          ,
        )
      ],
    );
    Widget gradeChartSection =
        createChartSection('constipation_chart_title', gradeChart, context, 3);

    return Column(
      children: <Widget>[typeChartSection, gradeChartSection],
    );
  }

  Widget createChartSection(
      String titleKey, Widget chart, BuildContext context, int flex) {
    return Expanded(
      flex: flex,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                PoopLocalizations.of(context).get(titleKey),
                style: Theme.of(context).textTheme.body2,
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

  Widget typeExplanation(BuildContext context, int startType, int endType, int gradeIndex) {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: Text(PoopLocalizations.of(context).get('type') +
          ' $startType - $endType: ' +
          PoopLocalizations.of(context).get('constipation_grade_$gradeIndex')),
    );
  }
}

class StoolTypeSeries {
  final String type;
  final int events;

  StoolTypeSeries({@required this.type, @required this.events});
}
