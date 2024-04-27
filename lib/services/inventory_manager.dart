import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InventoryManager {
  // database name and cols
  static const _databaseName = "sproutJournalDB.db";
  static const _databaseVersion = 1;
  static const table = "inventory";
  static const id = 1;

  // columns
  static const col1 = "plantID";
  static const col2 = "customDescription";
  static const col3 = "plantingDate";

  bool inited = false;

  // Singleton -> only one database per app

  // private constructor -> no other class can create an instance
  InventoryManager._privateConstructor();
  static final InventoryManager instance =
      InventoryManager._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      // creates and opens OR opens
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      _database = await openDatabase(path,
          version: _databaseVersion, onCreate: _onCreate);
      return _database!;
    }
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE $table table_name (
                id INTEGER PRIMARY KEY, 
                $col1 INTEGER NOT NULL,
                $col2 TEXT DEFAULT NULL,
                $col3 DATE DEFAULT (DATE('now'))
          )
          ''');
  }

  // TODO: implement tho functions
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
