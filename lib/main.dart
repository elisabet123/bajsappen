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
      onGenerateTitle: (BuildContext context) => PoopLocalizations.of(context).title,
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  Widget activeTab;
  List<DateTime> _poops = [];

  @override
  void initState() {
    super.initState();

    _read().then((_) {
      setState(() {
        activeTab = IDidItPage(
          lastPoop: _poops.isNotEmpty ? _poops.last : null,
          onPressed: _pooped,
        );
      });
    });
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    var poops = await helper.getAllPoops();
    if (poops != null) {
      setState(() {
        _poops = poops;
      });
    }
  }

  _savePoop(DateTime poop) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.insert(poop);
  }

  void _pooped(DateTime latestPoop) async {
    await _savePoop(latestPoop);

    setState(() {
      this._poops.add(latestPoop);
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          activeTab = StatisticPage(
            poops: _poops,
          );
          break;
        default:
          activeTab = IDidItPage(
            lastPoop: _poops.isNotEmpty ? _poops.last : null,
            onPressed: _pooped,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var myLocale = PoopLocalizations.of(context);
    print(myLocale.locale);
    return Scaffold(
      appBar: AppBar(
        title: Text(PoopLocalizations.of(context).title),
      ),
      body: activeTab,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            title: Text(PoopLocalizations.of(context).get('home')),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text(PoopLocalizations.of(context).get('statistics')),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onNavItemTapped,
      ),
    );
  }
}
