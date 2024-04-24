import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'note.dart';

class DatabaseHelper {
  static const _databaseName = "notes.db";
  static const _databaseVersion = 1;

  static const table = 'notes';
  static const id = 'id';
  static const title = 'title';
  static const content = 'content';
  static const noteColor = 'noteColor';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY,
        $title TEXT NOT NULL,
        $content TEXT NOT NULL,
        $noteColor TEXT NOT NULL
      )
    ''');
  }

  Future<int> insert(Note note) async {
    Database db = await instance.database;
    return await db.insert(table, note.toMap());
  }

  Future<List<Note>> queryAllNotes() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return maps.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.update(table, note.toMap(), where: '$id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(Note note) async { // Update the method to accept a Note object
    Database db = await instance.database;
    return await db.delete(table, where: '$id = ?', whereArgs: [note.id]);
  }
}
