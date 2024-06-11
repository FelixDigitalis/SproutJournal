import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';
import 'package:sprout_journal/utils/log.dart';

class JournalEntryManager extends DatabaseManager {
  static const table = "journalEntries";
  static const inventoryTable = "inventory";

  JournalEntryManager._privateConstructor();
  static final JournalEntryManager instance =
      JournalEntryManager._privateConstructor();

  Future<void> init(Database db, int version) async {
    Log().i("Creating journalEntry table in database");
    await db.execute('''
    CREATE TABLE $table (
      id INTEGER PRIMARY KEY, 
      journalManagerID INTEGER NOT NULL,
      text TEXT DEFAULT NULL,
      date DATE DEFAULT (DATETIME('now')),
      photoPath TEXT DEFAULT NULL,
      FOREIGN KEY (journalManagerID) REFERENCES $inventoryTable (id) ON DELETE CASCADE,
      CHECK (text IS NOT NULL OR photoPath IS NOT NULL)
    )
  ''');
  }

  Future<int> addJournalEntry(int journalManagerID, String text,
      {String? photoPath}) async {
    final db = await instance.database;
    final row = {
      'journalManagerID': journalManagerID,
      'text': text,
      'photoPath': photoPath
    };
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getAllJournalEntries() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> entries = await db.rawQuery('''
      SELECT 
        id,
        journalManagerID,
        text,
        strftime('%d.%m.%Y %H:%M', date) AS date,
        photoPath
      FROM 
        $table
      GROUP BY 
        date
      ORDER BY 
        date DESC
    ''');
    return entries;
  }

   Future<List<Map<String, dynamic>>> getJournalEntryById(int uuid) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> entries = await db.rawQuery('''
      SELECT 
        id,
        journalManagerID,
        text,
        strftime('%d.%m.%Y %H:%M', date) AS date,
        photoPath
      FROM 
        $table
      WHERE
        journalManagerID = $uuid
      GROUP BY 
        date
      ORDER BY 
        date DESC
    ''');
    return entries;
  }

  Future<int> deleteJournalEntry(int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateJournalEntry(int id, int journalManagerID, String text,
      {String? photoPath}) async {
    final db = await instance.database;
    final row = {
      'journalManagerID': journalManagerID,
      'text': text,
      'photoPath': photoPath
    };
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

 

  Future<int> addPhotoPathToJournalEntry(int id, String photoPath) async {
    final db = await instance.database;
    final row = {
      'photoPath': photoPath,
    };
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }
}
