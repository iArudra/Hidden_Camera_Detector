import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reports.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE reports(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            location TEXT,
            date TEXT,
            description TEXT,
            reportCount INTEGER
          )
          '''
        );
      },
      version: 1,
    );
  }

  Future<int> insertReport(Map<String, dynamic> report) async {
    Database db = await database;
    return await db.insert('reports', report);
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    Database db = await database;
    return await db.query('reports');
  }

  Future<void> updateReport(int id, int newCount) async {
    Database db = await database;
    await db.update(
      'reports',
      {'reportCount': newCount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
