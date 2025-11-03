import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../helper/sembast_web_database.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  // _db can be a sqflite Database on native or omitted on web where we
  // return a WebDatabase adapter directly. Use dynamic to accept both.
  static dynamic _db;

  DatabaseHelper._internal();

  /// Returns an sqflite Database on native platforms or a WebDatabase
  /// adapter on the web. The return type is dynamic to allow both.
  Future<dynamic> get database async {
    if (_db != null) return _db!;
    if (kIsWeb) {
      // Provide a sembast-backed adapter for web runs
      return WebDatabase('farmacio_app.db');
    }
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'farmacio_app.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firebaseUid TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        avatarUrl TEXT,
        isGoogleUser INTEGER DEFAULT 0,
        role TEXT NOT NULL DEFAULT 'student',
        classId TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      // Exemplo de migração simples (garante colunas novas):
      await db.execute(
        "ALTER TABLE users ADD COLUMN role TEXT NOT NULL DEFAULT 'student'",
      );
      await db.execute("ALTER TABLE users ADD COLUMN classId TEXT");
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
