import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../database_helpers.dart';
import '../poop.dart';
import '../pooplocalization.dart';

class CalendarPage extends StatefulWidget {
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List> _events = {};
  List _selectedEvents = [];
  DateTime _selectedDateTime = DateTime.now();

  CalendarController _calendarController;
  DatabaseHelper helper = DatabaseHelper.instance;

  CalendarPageState() {
    refresh();
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  refresh() {
    helper.getAllPoops().then((poops) {
      _events = {};
      setState(() {
        poops.forEach((poop) {
          var day = DateTime(
              poop.dateTime.year, poop.dateTime.month, poop.dateTime.day);
          if (_events.containsKey(day)) {
            _events[day].add(poop);
          } else {
            _events[day] = [poop];
          }
        });

        var selectedDay = DateTime(_selectedDateTime.year, _selectedDateTime.month, _selectedDateTime.day);
        _selectedEvents = _events[selectedDay] ?? [];
      });
    });
  }

  @override
  void didUpdateWidget(CalendarPage oldVariant) {
    refresh();
    super.didUpdateWidget(oldVariant);
  }

  void deletePoop(Poop poop) async {
    await helper.delete(poop);
    await refresh();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDateTime = day;
      _selectedEvents = events;
    });
  }

  Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(PoopLocalizations.of(context).get('remove_poop_title')),
            content:
            Text(PoopLocalizations.of(context).get('remove_poop_question')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(PoopLocalizations.of(context).get('remove'))),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(PoopLocalizations.of(context).get('cancel')),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      locale: 'sv_SV',
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(formatButtonVisible: false),
      events: _events,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.brown[400],
        todayColor: Colors.brown[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      onDaySelected: _onDaySelected,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((poop) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    '${DateFormat('HH:mm').format(poop.dateTime)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Container(
                    child: Image(
                      image: poop.hardness != null
                          ? AssetImage('assets/images/type-' +
                              poop.hardness.floor().toString() +
                              '.png')
                          : AssetImage('assets/images/empty.png'),
                      height: 50,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 0)),
                  ),
                  onLongPress: () async {
                    var delete = await confirmDelete(context);
                    if (delete) {
                      deletePoop(poop);
                    }
                  },
                ),
              ))
          .toList(),
    );
  }
}