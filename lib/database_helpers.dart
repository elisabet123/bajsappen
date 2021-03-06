import 'dart:io';
import 'dart:math';

import 'package:bajsappen/poop.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'poops';
final String columnEpoch = 'epoch';
final String columnHardness = 'hardness';
final String columnRating = 'grade';

final String personTable = 'person';
final String personId = 'id';

// singleton class to manage the database
class DatabaseHelper {
  static final _databaseName = "BajsappenDatabase.db";
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
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableName (
                $columnEpoch INTEGER PRIMARY KEY,
                $columnHardness INTEGER,
                $columnRating INTEGER
              )
              ''');
    await db.execute('''
              CREATE TABLE $personTable ( $personId STRING PRIMARY KEY )
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    /*
    if (oldVersion < 2) {
      await db.execute('''
              ALTER TABLE $tableName add column $columnHardness INTEGER 
              ''');
    }
    */
  }

  // Database helper methods:
  Future<int> insertPoop(Poop poop) async {
    Database db = await database;
    int id = await db.insert(tableName, <String, dynamic>{
      columnEpoch: poop.dateTime.millisecondsSinceEpoch,
      columnHardness: poop.hardness,
      columnRating: poop.rating
    });
    return id;
  }

  Future<bool> delete(Poop poop) async {
    Database db = await database;
    int id = await db.delete(tableName,
        where: '$columnEpoch = ?',
        whereArgs: [poop.dateTime.millisecondsSinceEpoch]);
    return id > 0;
  }

  Future<List<Poop>> getAllPoops([int sinceEpoch = 0]) async {
    Database db = await database;

    List<Map> maps = await db.query(
      tableName,
      orderBy: '$columnEpoch DESC',
      where: '$columnEpoch > $sinceEpoch',
    );
    return List.generate(maps.length, (i) {
      return Poop(DateTime.fromMillisecondsSinceEpoch(maps[i][columnEpoch]),
          maps[i][columnHardness], maps[i][columnRating]);
    });
  }

  void clear() async {
    Database db = await database;

    db.delete(tableName);
  }

  Future<String> getPersonalCode() async {
    Database db = await database;
    List<Map> maps = await db.query(personTable);
    if (maps.length > 0) {
      return maps[0][personId];
    } else {
      var newCode = getRandString(5);
      await setPersonalCode(newCode);
      return newCode;
    }
  }

  setPersonalCode(String code) async {
    Database db = await database;
    await db.delete(personTable);
    if (code.isNotEmpty) {
      await db.insert(personTable, {personId: code});
    }
  }

  String getRandString(int len) {
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890_-';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
}
