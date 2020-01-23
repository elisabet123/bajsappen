import 'package:flutter/material.dart';
import 'package:flutter_app/ididitpage.dart';
import 'package:flutter_app/poopbutton.dart';
import 'package:flutter_app/statistics/statisticspage.dart';

void main() => runApp(Bajsappen());

class Bajsappen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bajsappen',
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
  List<DateTime>_poops = [];

  void _pooped(DateTime latestPoop) {
    setState(() {
      this._poops.add(latestPoop);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(_selectedIndex) {
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
    if (activeTab == null) {
      _selectedIndex = 0;
      activeTab = IDidItPage(
        lastPoop: _poops.isNotEmpty ? _poops.last : null,
        onPressed: _pooped,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bajsappen'),
      ),
      body: activeTab,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            title: Text('Statistik'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
