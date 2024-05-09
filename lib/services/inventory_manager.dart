import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/log.dart';

class InventoryManager {
  // database name and cols
  static const _databaseName = "sproutJournalDB.db";
  static const _databaseVersion = 1;
  static const table = "inventory";
  static const id = 1;

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
      try {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);
        _database = await openDatabase(path,
            version: _databaseVersion, onCreate: _onCreate);
        return _database!;
      } catch (e) {
        Log().e(e.toString());
        throw Exception('Database could not be initialized.');
      }
    }
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
                id INTEGER PRIMARY KEY, 
                plantID INTEGER NOT NULL,
                description TEXT DEFAULT NULL,
                plantingDate DATE DEFAULT (DATE('now'))
          )
          ''');
  }

  Future<int> addPlantToInventory(int plantID, String description) async {
    final db = await instance.database;
    final row = {
      'plantID': plantID,
      'description': description,
    };
    return await db.insert(table, row);
  }

    Future<List<Map<String, dynamic>>> getAllPlants() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> plants = await db.rawQuery('''
      SELECT 
        id,
        plantID,
        description,
        strftime('%d.%m.%Y', plantingDate) AS plantingDate
      FROM 
        $table
      ORDER BY 
        plantingDate ASC
    ''');
    return plants;
  }

  // Future<int> delete(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table);
  // }
}
