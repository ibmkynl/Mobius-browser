import 'dart:io';

import 'package:mobius_browser/Models/FavModel.dart';
import 'package:mobius_browser/Models/HistoryModel.dart';
import 'package:mobius_browser/Models/TabModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String tabTable = 'tab_table';
  String tabId = 'id';
  String tabLink = 'link';
  String historyTable = "history_table";
  String historyId = "id";
  String historyLink = "link";
  String historyDate = "date";
  String favTable = "fav_table";
  String favId = "id";
  String favLink = "link";
  String favName = "name";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'mobius.db';

    // Open/create the database at a given path
    var tabDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return tabDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE $tabTable($tabId INTEGER PRIMARY KEY AUTOINCREMENT, $tabLink TEXT)''');
    await db.execute(
        '''CREATE TABLE $historyTable($historyId INTEGER PRIMARY KEY AUTOINCREMENT, $historyLink TEXT,$historyDate INTEGER)''');
    await db.execute(
        '''CREATE TABLE $favTable($favId INTEGER PRIMARY KEY AUTOINCREMENT, $favLink TEXT,$favName TEXT)''');
  }

  Future insert(model, int) async {
    Database db = await this.database;
    if (int == 1) {
      print("if");
      await db.insert(tabTable, model.toMap());
    } else if (int == 2) {
      print("else if ");
      await db.insert(historyTable, model.toMap());
    } else {
      print("else");
      await db.insert(favTable, model.toMap());
    }
  }

  Future update(model, int) async {
    var db = await this.database;
    if (int == 1) {
      await db.update(tabTable, model.toMap(),
          where: '$tabId = ?', whereArgs: [model.id]);
    } else {
      await db.update(favTable, model.toMap(),
          where: '$tabId = ?', whereArgs: [model.id]);
    }
    print(await db.query(DatabaseHelper().historyTable));
  }

  Future delete(int id, int) async {
    var db = await this.database;
    if (int == 1) {
      await db.rawDelete('DELETE FROM $tabTable WHERE $tabId = $id');
    } else if (int == 2) {
      await db.rawDelete('DELETE FROM $historyTable WHERE $historyId = $id');
    } else {
      await db.rawDelete('DELETE FROM $favTable WHERE $favId = $id');
    }
  }

  Future<int> getCount(value) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x;
    if (value == 1) {
      x = await db.rawQuery('SELECT COUNT (*) from $tabTable');
    } else if (value == 2) {
      x = await db.rawQuery('SELECT COUNT (*) from $historyTable');
    } else {
      x = await db.rawQuery('SELECT COUNT (*) from $favTable');
    }
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<TabModel>> getTabList() async {
    var tabMapList = await getTabMapList();
    int count = tabMapList.length;

    List<TabModel> tabList = List<TabModel>();
    for (int i = 0; i < count; i++) {
      tabList.add(TabModel.fromMapObject(tabMapList[i]));
    }

    return tabList;
  }

  Future<List<Map<String, dynamic>>> getTabMapList() async {
    Database db = await this.database;

    var result = await db.query(tabTable, orderBy: '$tabId DESC');
    return result;
  }

  Future<List<HistoryModel>> getHistoryList() async {
    var historyMapList = await getHistoryMapList();
    int count = historyMapList.length;

    List<HistoryModel> historyList = List<HistoryModel>();
    for (int i = 0; i < count; i++) {
      historyList.add(HistoryModel.fromMapObject(historyMapList[i]));
    }

    return historyList;
  }

  Future<List<Map<String, dynamic>>> getHistoryMapList() async {
    Database db = await this.database;

    var result = await db.query(historyTable, orderBy: '$historyId DESC');
    return result;
  }

  Future<List<FavModel>> getFavList() async {
    var favMapList = await getFavMapList();
    int count = favMapList.length;

    List<FavModel> favList = List<FavModel>();
    for (int i = 0; i < count; i++) {
      favList.add(FavModel.fromMapObject(favMapList[i]));
    }

    return favList;
  }

  Future<List<Map<String, dynamic>>> getFavMapList() async {
    Database db = await this.database;

    var result = await db.query(favTable, orderBy: '$favId DESC');
    return result;
  }
}
