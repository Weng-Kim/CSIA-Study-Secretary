import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:math';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

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
            examDate TEXT NOT NULL
            description TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE custom_exams(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            examDate TEXT NOT NULL
            description TEXT
          )
        ''');

        _insertPredefinedExams(db);
      },
    );
  }

  Future<void> _insertPredefinedExams(Database db) async {
    final predefinedExamTypes = [
      {'name': 'IB May Session 2024', 'examDate': '25/4/2024 to 17/5/2024'},
      {
        'name': 'IB November Session 2024',
        'examDate': '21/10/2024 to 11/11/2024'
      },
      {
        'name': 'A-Levels 2024',
        'examDate': '3/7/2024 to 7/11/2024',
        'description': 'Oral is in July, Written papers start in October'
      },
      {
        'name': 'O-Levels 2024',
        'examDate': '3/7/2024 to 11/11/2024',
        'description': 'Oral and Mother Tongue Listening is in July, Written papers start in October'
      },
    ];

    for (var exam in predefinedExamTypes) {
      await db.insert('exam_types', exam);
    }
  }

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

    Map<String, dynamic> user = {
      'username': username,
      'password': password,
      'firstName': firstName,
      'course': course,
      'examYear': examYear,
      'subjects': subjects.join(','),
      'levels': levels.join(','),
      'messages': messages.join(','),
      'goals': goals.join(',')
    };

    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> fetchAllExams() async {
    final db = await initDatabase();

    final predefinedExams = await db.query('exam_types');
    final customExams = await db.query('custom_exams');

    return [...predefinedExams, ...customExams];
  }

  Future<List<Map<String, dynamic>>> fetchProfile() async {
    final db = await initDatabase();
    return await db.query('users');
  }

  Future<Map<String, String?>> fetchRandomMessageAndGoal() async {
    final db = await initDatabase();

    // Fetch all users' messages and goals
    final List<Map<String, dynamic>> users = await db.query('users');

    if (users.isNotEmpty) {
      final randomUser = users[Random().nextInt(users.length)];
      return {
        'message': randomUser['messages'],
        'goal': randomUser['goals'],
      };
    }

    return {'message': null, 'goal': null};
  }

  Future<void> insertCustomExam({
    required String name,
    required String examDate,
    String? description,
  }) async {
    final db = await initDatabase();
    await db.insert('custom_exams', {
      'name': name,
      'examDate': examDate,
      'description': description ?? '',
    });
  }
}
