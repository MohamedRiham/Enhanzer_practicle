import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:enhanzer_practicle/models/api_response.dart';

class DbManager {
  static final DbManager _instance = DbManager._internal();
  factory DbManager() => _instance;

  static Database? _database;

  DbManager._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'api_response.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ApiResponseData(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            User_Code TEXT,
            User_Display_Name TEXT,
            Email TEXT,
            User_Employee_Code TEXT,
            Company_Code TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertApiResponse(ResponseBody responseBody) async {
    final db = await database;

    await db.insert(
      'ApiResponseData',
      responseBody.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ResponseBody>> fetchAllResponses() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('ApiResponseData');

    return List.generate(maps.length, (i) {
      return ResponseBody.fromJson(maps[i]);
    });
  }
}
