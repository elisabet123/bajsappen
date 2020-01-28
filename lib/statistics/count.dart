import 'package:bajsappen/statistics/statisticscard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pooplocalization.dart';
import 'allpooppage.dart';

class CounterWidget extends StatelessWidget {
  final int count;
  final DateTime firstPoop;
  final TextStyle _highlightStyle;
  final List<DateTime> _poops;
  final Function(DateTime) _onPoopDeleted;

  CounterWidget(this._poops, this._highlightStyle, this._onPoopDeleted, {Key key})
      : this.count = _poops.length,
        this.firstPoop = _poops.isNotEmpty ? _poops.first : DateTime.now(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StatisticsCard(
        children: <Widget>[
          Text(PoopLocalizations.of(context).get('you_have_pooped')),
          Text(
            '$count',
            style: _highlightStyle,
          ),
          Text(PoopLocalizations.of(context).get('times_since')),
          Text('${DateFormat('yyyy-MM-dd').format(firstPoop)}'),
        ],
        onTap: () => Navigator.of(context).push(AllPoopPage(_poops, _onPoopDeleted).getMaterialPageRoute()),
      ),
    );
  }
}
