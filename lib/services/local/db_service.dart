// lib/services/database_service.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static final LocalDatabaseService db = LocalDatabaseService._();
  static Database? _database;

  factory LocalDatabaseService() {
    return db;
  }

  LocalDatabaseService._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'techtestdb.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        image TEXT,
        CHECK(LENGTH(username) <= 50),
        CHECK(LENGTH(email) <= 50),
        CHECK(LENGTH(password) <= 60)
      )
    ''');
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        code REAL,
        user_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
      )
    ''');
  }
}
