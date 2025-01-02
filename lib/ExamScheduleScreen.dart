import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studysecretary_alpha/DatabaseHelper.dart';

class ExamScheduleScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam Schedule')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchExamSchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading exam schedule.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No exams found.'));
          }

          final exams = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              final examName = exam['name'] ?? exam['examTypeName']; // Custom or predefined
              final examDate = exam['examDate'];

              return ListTile(
                title: Text(examName),
                subtitle: Text('Exam Date: $examDate'),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchExamSchedule() async {
    return await dbHelper.fetchAllExams();
  }
}
