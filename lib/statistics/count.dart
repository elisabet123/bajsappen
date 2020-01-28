import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pooplocalization.dart';

class CounterWidget extends StatelessWidget {
  final int count;
  final DateTime firstPoop;
  final TextStyle highlightStyle;

  CounterWidget({Key key, List<DateTime> poops, this.highlightStyle})
      : this.count = poops.length,
        this.firstPoop = poops.isNotEmpty ? poops.first : DateTime.now(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StatisticsCard(
        children: <Widget>[
          Text(PoopLocalizations.of(context).get('you_have_pooped')),
          Text(
            '$count',
            style: highlightStyle,
          ),
          Text(PoopLocalizations.of(context).get('times_since')),
          Text('${DateFormat('yyyy-MM-dd').format(firstPoop)}'),
        ],
        onTap: () {},
      ),
    );
  }
}
