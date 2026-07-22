import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/high_score_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'memory_match.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE HighScores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player_name TEXT,
            difficulty TEXT,
            moves INTEGER,
            time_seconds INTEGER,
            date TEXT
          )
        ''');
      },
    );
  }

  // Insert a new high score
  Future<int> insertScore(HighScoreModel score) async {
    final db = await database;
    return await db.insert('HighScores', score.toMap());
  }

  // Get all scores, sorted best-first (fewest moves, then least time)
  Future<List<HighScoreModel>> getScores() async {
    final db = await database;
    final result = await db.query(
      'HighScores',
      orderBy: 'moves ASC, time_seconds ASC',
    );
    return result.map((map) => HighScoreModel.fromMap(map)).toList();
  }

  // Get scores filtered by difficulty
  Future<List<HighScoreModel>> getScoresByDifficulty(String difficulty) async {
    final db = await database;
    final result = await db.query(
      'HighScores',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
      orderBy: 'moves ASC, time_seconds ASC',
    );
    return result.map((map) => HighScoreModel.fromMap(map)).toList();
  }

  // Delete all scores (optional - useful for reset/testing)
  Future<void> clearScores() async {
    final db = await database;
    await db.delete('HighScores');
  }
}