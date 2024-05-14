import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'database_manager.dart';
// import 'log.dart';

class JournalEntryManager extends DatabaseManager {
  static const table = "journal_entries";
  static const journalManagerTable = "inventory";

  JournalEntryManager._privateConstructor();
  static final JournalEntryManager instance =
      JournalEntryManager._privateConstructor();

  @override
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
                id INTEGER PRIMARY KEY, 
                journalManagerID INTEGER NOT NULL,
                text TEXT NOT NULL,
                date DATE DEFAULT (DATE('now')),
                photoPath TEXT DEFAULT NULL,
                FOREIGN KEY (journalManagerID) REFERENCES $journalManagerTable (id) ON DELETE CASCADE
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
        strftime('%d.%m.%Y', date) AS date,
        photoPath
      FROM 
        $table
      ORDER BY 
        date ASC
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

  Future<Map<String, dynamic>?> getJournalEntryById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results =
        await db.query(table, where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}