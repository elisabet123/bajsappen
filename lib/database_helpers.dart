import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'poopTable';
final String columnEpoch = 'epoch';

// singleton class to manage the database
class DatabaseHelper {
  static final _databaseName = "Bajsappen.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableName (
                $columnEpoch INTEGER PRIMARY KEY
              )
              ''');
  }

  // Database helper methods:
  Future<int> insert(DateTime poop) async {
    Database db = await database;
    int id = await db.insert(tableName,
        <String, dynamic>{columnEpoch: poop.millisecondsSinceEpoch});
    return id;
  }

  Future<List<DateTime>> getAllPoops() async {
    Database db = await database;
    List<Map> maps = await db.query(tableName, orderBy: columnEpoch);
    if (maps.length > 0) {
      List<DateTime> resultList = [];
      maps.forEach((element) => resultList.add(DateTime.fromMillisecondsSinceEpoch(element[columnEpoch])));
      return resultList;
    }
    return null;
  }
}
