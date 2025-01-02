import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Initialize the database
  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'user_data.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          password TEXT,
          firstName TEXT,
          course TEXT,
          examYear INTEGER,
          subjects TEXT,
          levels TEXT,
          messages TEXT,
          goals TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE exam_types(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE custom_exams(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          examDate TEXT NOT NULL
        )
      ''');

        _insertPredefinedExams(db);
      },
    );
  }
  // Method to insert predefined exams
  Future<void> _insertPredefinedExams(Database db) async {
    final predefinedExamTypes = [
      {'name': 'IB May Session 2024', 'description': '25/4/2024 to 17/5/2024'},
      {'name': 'IB November Session 2024', 'description': '21/10/2024 to 11/11/2024'},
      {'name': 'A Levels June Series 2024', 'description': 'Late April to mid-June'},
      {'name': 'A Levels November Series 2024', 'description': 'Early October to mid-November'},
      {'name': 'O Levels June Series 2024', 'description': 'Late April to mid-June'},
      {'name': 'O Levels November Series 2024', 'description': 'Early October to mid-November'},
      {'name': 'IB May Session 2025', 'description': 'Late April to mid-May'},
      {'name': 'IB November Session 2025', 'description': 'October-November'},
      {'name': 'A Levels June Series 2025', 'description': 'May-June'},
      {'name': 'A Levels November Series 2025', 'description': 'October-November'},
      {'name': 'O Levels June Series 2025', 'description': 'May-June'},
      {'name': 'O Levels November Series 2025', 'description': 'October-November'},
      {'name': 'IB May Session 2026', 'description': 'Late April to mid-May'},
      {'name': 'IB November Session 2026', 'description': 'October-November'},
      {'name': 'A Levels June Series 2026', 'description': 'May-June'},
      {'name': 'A Levels November Series 2026', 'description': 'October-November'},
      {'name': 'O Levels June Series 2026', 'description': 'May-June'},
      {'name': 'O Levels November Series 2026', 'description': 'October-November'}
    ];

    for (var exam in predefinedExamTypes) {
      await db.insert('exam_types', exam);
    }
  }

  // Method to add a custom exam
  Future<int> insertUser({
    required String username,
    required String password,
    required String firstName,
    required String course,
    required int examYear,
    required List<String> subjects,
    required List<String> levels,
    required List<String> messages,
    required List<String> goals,
  }) async {
    final db = await initDatabase();

    String subjectsString = subjects.join(',');
    String levelsString = levels.join(',');
    String messagesString = messages.join(',');
    String goalsString = goals.join(',');

    Map<String, dynamic> user = {
      'username': username,
      'password': password,
      'firstName': firstName,
      'course': course,
      'examYear': examYear,
      'subjects': subjectsString,
      'levels': levelsString,
      'messages': messagesString,
      'goals': goalsString
    };

    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> fetchAllExams() async {
    try {
      final db = await initDatabase();

      final predefinedExams = await db.rawQuery('''
      SELECT et.name AS examTypeName, et.description AS description
      FROM exam_types et
    ''');

      final customExams = await db.query('custom_exams');

      return [...predefinedExams, ...customExams];
    } catch (e) {
      print('Error fetching exams: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchProfile() async {
    try {
      final db = await initDatabase();

      // Query all rows from the 'users' table
      final users = await db.query('users');

      return users;
    } catch (e) {
      print('Error fetching Profile: $e');
      return [];
    }
  }

}
