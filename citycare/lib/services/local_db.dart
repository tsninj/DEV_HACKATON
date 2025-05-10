import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  static Future<Database> _initDB() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, 'reports.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT,
            address TEXT,
            caption TEXT,
            tags TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertReport({
    required String imagePath,
    required String address,
    required String caption,
    required List<String> tags,
  }) async {
    final db = await database;
    await db.insert(
      'reports',
      {
        'imagePath': imagePath,
        'address': address,
        'caption': caption,
        'tags': tags.join(','),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('reports');
  }
}