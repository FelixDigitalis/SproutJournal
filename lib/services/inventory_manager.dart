import 'dart:async';
// import 'package:sprout_journal/utils/log.dart';
import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';

class InventoryManager extends DatabaseManager {
  static const table = "inventory";

  InventoryManager._privateConstructor();
  static final InventoryManager instance =
      InventoryManager._privateConstructor();

  Future<void> init(Database db, int version) async {
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
        plantingDate DESC
    ''');
    return plants;
  }

  Future<int> updatePlantingDate(int id, String newDate) async {
    final db = await instance.database;
    final row = {
      'plantingDate': newDate,
    };
    return await db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePlant(int id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(
      table, 
    );
  }
}
