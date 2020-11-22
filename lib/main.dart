import 'package:bajsappen/calendar/calendarpage.dart';
import 'package:bajsappen/sync_dialog.dart';
import 'package:bajsappen/visualize/allpooppage.dart';
import 'package:bajsappen/statistics/statisticspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'database_helpers.dart';
import 'ididitpage.dart';
import 'pooplocalization.dart';

void main() => runApp(Bajsappen());

class Bajsappen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          PoopLocalizations.of(context).title,
      localizationsDelegates: [
        const BajsLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('sv'), // Swedish
      ],
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Widget activeTab;
  String personalCode;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  refresh() async {
    String personalCode = await DatabaseHelper.instance.getPersonalCode();
    setState(() {
      this.personalCode = personalCode;
      activeTab = getCurrentTab();
    });
  }

  Widget getCurrentTab() {
    switch (_selectedIndex) {
      case 1:
        return StatisticPage();
        break;
      case 2:
        return CalendarPage();
        break;
      default:
        return IDidItPage();
        break;
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      activeTab = getCurrentTab();
    });
  }

  void _showList() async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AllPoopPage(0)));
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PoopLocalizations.of(context).title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _showInputDialog(context);
              }),
          IconButton(icon: Icon(Icons.list), onPressed: _showList),
        ],
      ),
      body: activeTab,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: PoopLocalizations.of(context).get('home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: PoopLocalizations.of(context).get('statistics'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: PoopLocalizations.of(context).get('calendar'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onNavItemTapped,
      ),
    );
  }

  _showInputDialog(BuildContext context) async {
    String personalCode = await showDialog(
      context: context,
      child: new SyncDialog(this.personalCode),
    );
    if (personalCode != null) {
      // BUG: this doesn't cause the page to refresh
      await DatabaseHelper.instance.setPersonalCode(personalCode);
      this.refresh();
    }
  }
}
