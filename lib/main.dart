import 'package:bajsappen/poop.dart';
import 'package:bajsappen/statistics/allpooppage.dart';
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
  List<Poop> _poops = [];
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();

    read();
  }

  read() async {
    var poops = await helper.getAllPoops() ?? [];

    setState(() {
      _poops = poops;
      switch (_selectedIndex) {
        case 1:
          activeTab = StatisticPage();
          break;
        default:
          activeTab = IDidItPage(
            poops != null && poops.isNotEmpty ? poops.last : null,
            _savePoop,
          );
          break;
      }
    });
  }

  _savePoop(Poop poop) async {
    await helper.insertPoop(poop);
    await this.read();
  }

  _deletePoop(Poop poop) async {
    await helper.delete(poop);
    await this.read();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 1:
          activeTab = StatisticPage();
          break;
        default:
          activeTab = IDidItPage(
            _poops.isNotEmpty ? _poops.last : null,
            _savePoop,
          );
          break;
      }
    });
  }

  void _showList() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AllPoopPage(_poops, _deletePoop)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PoopLocalizations.of(context).title),
        actions: <Widget>[
          // Add 3 lines from here...
          IconButton(icon: Icon(Icons.list), onPressed: _showList),
        ],
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
