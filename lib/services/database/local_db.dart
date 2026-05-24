import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' if (dart.library.io) 'package:sqflite_common_ffi/sqflite_ffi.dart';


import 'package:path/path.dart';


class LocalDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // No special FFI initialization required for sqflite on any platform

  static Future<void> _initFactory() async {}

static Future<Database> _initDB() async {
    await _initFactory();
    String path = join(await getDatabasesPath(), 'careerguide.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception("Database initialization timed out. If on Web, sqlite3.wasm might be missing.");
    });
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT UNIQUE,
        first_name TEXT,
        last_name TEXT,
        age INTEGER,
        class_level TEXT,
        stream TEXT,
        city TEXT,
        interests TEXT,
        favorite_subjects TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE universities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        city TEXT,
        category TEXT,
        type TEXT,
        level TEXT,
        image_url TEXT,
        description TEXT,
        filiere_list TEXT,
        scholarships TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        message TEXT,
        reply TEXT,
        timestamp TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  // Seed with initial data from JSON
  static Future<void> seedDatabase() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM universities');
    final count = result.isNotEmpty ? (result.first['cnt'] as int?) : 0;
    
    if (count == 0) {
      final String response = await rootBundle.loadString('assets/data/universities.json');
      final List<dynamic> data = json.decode(response);
      
      for (var item in data) {
        await db.insert('universities', {
          'name': item['name'],
          'city': item['city'],
          'category': 'Université',
          'type': 'Public',
          'level': 'Post-Bac',
          'filiere_list': json.encode(item['filieres'] ?? []),
          'scholarships': json.encode([]),
          'description': 'Établissement situé à ${item['city']}.'
        });
      }
    }
  }
}
