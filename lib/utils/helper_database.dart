// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const db_name = "crud.db";
  static const db_version = 1;
  static const db_table = "TODOTable";
  static const col_id = "id";
  static const col_name = "name";
  static const col_desc = "description";

  static final DatabaseHelper instance = DatabaseHelper();

  static Database? _databse;
  Future<Database?> get database async {
    _databse ??= await init();
    return _databse;
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, db_name);
    return await openDatabase(path, version: db_version, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    db.execute("""
  CREATE TABLE $db_table(
  $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
  $col_name TEXT NOT NULL,
  $col_desc TEXT NOT NULL
  )
  """);
  }

  insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(db_table, row);
  }

  Future<List<Map<String, dynamic>>> readData() async {
    Database? db = await instance.database;
    return await db!.query(db_table);
  }

  Future<int> updataData(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[col_id];
    return await db!
        .update(db_table, row, where: "$col_id = ?", whereArgs: [id]);
  }

  Future<int> deleteData(int id) async {
    Database? db = await instance.database;
    return db!.delete(db_table, where: "$col_id = ?", whereArgs: [id]);
  }
  Future<Map<String, dynamic>> readNoteById(int id) async {
    Database? db = await instance.database;
    final result = await db!.query(db_table, where: '$col_id = ?', whereArgs: [id]);
    return result.first;
  }
}
