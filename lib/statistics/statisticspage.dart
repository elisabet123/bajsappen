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

  final List<bool> selectedDateRange = [true, false, false];

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
    Duration refreshSince = selectedDateRange[0]
        ? Duration(days: 7)
        : selectedDateRange[1]
            ? Duration(days: 31)
            : Duration(days: 365 * 10); // there is no maxint
    List<Poop> poops = await helper.getAllPoops(
            DateTime.now().subtract(refreshSince).millisecondsSinceEpoch) ??
        [];

    List<Widget> refreshedWidgets = [];
    refreshedWidgets.add(CounterWidget(
      poops,
      highlightStyle,
      onPoopDeleted,
    ));
    refreshedWidgets
        .add(WeekdayStats(poops: poops, highlightStyle: highlightStyle));
    refreshedWidgets.add(TimeOfDayStats(poops, highlightStyle: highlightStyle));
    refreshedWidgets
        .add(ConstipationStats(poops: poops, highlightStyle: highlightStyle));
    statisticsWidgets = refreshedWidgets;
  }

  StatisticPageState() {
    refresh().then((poops) {
      setState(() {
        statisticsWidgets = statisticsWidgets;
      });
    });
  }

  _setDateRange(int selectedRange) {
    selectedDateRange.fillRange(0, 3, false);
    selectedDateRange[selectedRange] = true;
    refresh().then((poops) {
      setState(() {
        statisticsWidgets = statisticsWidgets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding: EdgeInsets.all(0),
            mainAxisSize: MainAxisSize.min,
            buttonHeight: 47,
            children: <Widget>[
              FlatButton(
                child: Text("Senaste veckan"),
                color: selectedDateRange[0] ? Colors.blueAccent : Colors.white,
                padding: EdgeInsets.all(8),
                onPressed: () => _setDateRange(0),
              ),
              FlatButton(
                child: Text("Senaste månaden"),
                color: selectedDateRange[1] ? Colors.blueAccent : Colors.white,
                padding: EdgeInsets.all(8),
                onPressed: () => _setDateRange(1),
              ),
              FlatButton(
                child: Text("All data"),
                color: selectedDateRange[2] ? Colors.blueAccent : Colors.white,
                padding: EdgeInsets.all(8),
                onPressed: () => _setDateRange(2),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: statisticsWidgets,
          ),
        ),
      ],
    );
  }
}
