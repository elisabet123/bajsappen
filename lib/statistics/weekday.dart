import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class WeekdayStats extends StatelessWidget {

  final Map<int, int> poopsByWeekday;
  final String mostPopularDay;

  WeekdayStats({Key key, List<DateTime> poops}) :
    this.poopsByWeekday = groupByDay(poops),
    this.mostPopularDay = getMostPopularDay(groupByDay(poops)),
    super(key: key);

  static Map<int, int> groupByDay(List<DateTime> poops) {
    Map<int, List<DateTime>> days = groupBy(poops, (datetime) => datetime.weekday);
    return days.map((key, value) => MapEntry(key, value.length));
  }

  static String getMostPopularDay(Map<int, int> dailyStats) {
    int index = maxBy(dailyStats.entries, (entry) => entry.value).key;

    List<String> weekdayNames = ['Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lördag', 'Söndag'];
    return weekdayNames[index - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
          },
          child: Container(
            width: 300,
            height: 100,
            child: Center(
                child: Text('Din populäraste bajsardag: $mostPopularDay')
            ),
          ),
        ),
      ),
    );
  }
}
