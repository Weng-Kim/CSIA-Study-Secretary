import 'package:flutter/material.dart';
import 'package:study_secretary_flutter_final/DatabaseHelper.dart';
import 'package:study_secretary_flutter_final/NotificationService.dart';
import 'AddYourExams.dart';
import 'package:timezone/timezone.dart' as tz;

class ExamScheduleScreen extends StatefulWidget {
  const ExamScheduleScreen({super.key});

  @override
  _ExamScheduleScreenState createState() => _ExamScheduleScreenState();
}

class _ExamScheduleScreenState extends State<ExamScheduleScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final int userId = 1; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await NotificationService().showMotivationalBanner(userId);
    await scheduleExamReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Schedule')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchExamSchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading exam schedule.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No exams found. Add your school examinations.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddYourExams()),
                      );
                    },
                    child: const Text('Add Exam'),
                  ),
                ],
              ),
            );
          }

          final exams = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              final examName = exam['name'] ?? exam['examTypeName']; // Custom or predefined
              final examDateStr = exam['examDate'];
              final examDate = DateTime.tryParse(examDateStr) ?? DateTime.now();

              return ListTile(
                title: Text(examName),
                subtitle: Text('Exam Date: ${examDate.toLocal()}'),
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

  Future<void> scheduleExamReminders() async {
    final exams = await fetchExamSchedule();
    for (var exam in exams) {
      final examName = exam['name'] ?? exam['examTypeName'];
      final examDateStr = exam['examDate'];
      final examDate = DateTime.tryParse(examDateStr);

      if (examDate != null) {
        await NotificationService().scheduleExamReminder(examName, examDate);
      }
    }
  }
}
