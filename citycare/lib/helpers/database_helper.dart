import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dev_hackaton.db');
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        videoPath TEXT,
        location TEXT,
        caption TEXT,
        tag TEXT,
              timestamp TEXT

      )
    ''');
  }

  Future<void> insertEntry(
    String videoPath,
    String address,
    String caption,
    List<String> tags,
  ) async {
    final db = await instance.database;
    final timestamp = DateTime.now().toIso8601String();

    await db.insert('posts', {
      'videoPath': videoPath,
      'location': address,
      'caption': caption,
      'tag': tags.join(','),
      'timestamp': timestamp,
    });
  }

  Future<List<Map<String, dynamic>>> fetchEntry() async {
    final db = await instance.database;
    return await db.query('posts');
  }
}
