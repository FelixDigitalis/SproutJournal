import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../services/log.dart';

abstract class DatabaseManager {
  static const _databaseName = "sproutJournalDB.db";
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      try {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);
        _database = await openDatabase(path,
            version: _databaseVersion, onCreate: onCreate);
        return _database!;
      } catch (e) {
        Log().e(e.toString());
        throw Exception('Database could not be initialized.');
      }
    }
  }

  Future<void> onCreate(Database db, int version);
}
