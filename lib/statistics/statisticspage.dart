import 'package:bajsappen/pooplocalization.dart';
import 'package:bajsappen/pooppagestate.dart';
import 'package:bajsappen/statistics/constipation.dart';
import 'package:bajsappen/statistics/count.dart';
import 'package:bajsappen/statistics/timeofday.dart';
import 'package:bajsappen/statistics/weekday.dart';
import 'package:flutter/material.dart';

import '../database_helpers.dart';
import '../poop.dart';

class StatisticPage extends StatefulWidget {
  @override
  StatisticPageState createState() => StatisticPageState();
}

class StatisticPageState extends PoopPageState {
  List<Widget> statisticsWidgets = [];

  final List<bool> selectedDateRange = [true, false, false, false];

  final TextStyle highlightStyle = TextStyle(
    color: Colors.deepOrange,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  refresh() async {
    Duration refreshSince = selectedDateRange[0]
        ? Duration(days: 7)
        : selectedDateRange[1]
            ? Duration(days: 31)
            : Duration(days: 365 * 10); // there is no maxint
    List<Poop> poops = await super.getAllPoops(
            DateTime.now().subtract(refreshSince).millisecondsSinceEpoch) ??
        [];

    List<Widget> refreshedWidgets = [];
    refreshedWidgets.add(CounterWidget(
      poops,
      highlightStyle,
      super.deletePoop,
    ));
    refreshedWidgets.add(WeekdayStats(poops, highlightStyle: highlightStyle));
    refreshedWidgets.add(TimeOfDayStats(poops, highlightStyle: highlightStyle));
    refreshedWidgets
        .add(ConstipationStats(poops, highlightStyle: highlightStyle));
    setState(() {
      statisticsWidgets = refreshedWidgets;
    });
  }

  _setDateRange(int selectedRange) {
    selectedDateRange.fillRange(0, 3, false);
    selectedDateRange[selectedRange] = true;
    refresh();
  }

  List<Widget> _getTimeRangeButtons(BuildContext context) {
    return List.generate(3, (index) {
      return FlatButton(
        child: Text(PoopLocalizations.of(context)
            .get("statistics_date_range_" + index.toString())),
        color: selectedDateRange[index] ? Colors.blueAccent : Colors.white,
        padding: EdgeInsets.all(7),
        shape: Border(),
        onPressed: () => _setDateRange(index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          margin: EdgeInsets.only(left: 8, top: 16, right: 8, bottom: 4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: EdgeInsets.all(0),
              mainAxisSize: MainAxisSize.min,
              buttonHeight: 48,
              children: _getTimeRangeButtons(context),
            ),
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
