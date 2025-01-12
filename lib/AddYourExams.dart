import 'package:flutter/material.dart';
import 'package:studysecretary_alpha/ExamScheduleScreen.dart';
import 'package:studysecretary_alpha/Home.dart';
import 'DatabaseHelper.dart'; // Import the database helper

class AddYourExams extends StatefulWidget {
  const AddYourExams({super.key});

  @override
  _AddYourExamsState createState() => _AddYourExamsState(); // Corrected state class
}

class _AddYourExamsState extends State<AddYourExams> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper(); // Initialize database helper

  // Text input controllers for `custom_exams`
  final TextEditingController _examNameController = TextEditingController();
  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _examDescriptionController = TextEditingController();

  void _saveExamData() async {
    if (_formKey.currentState!.validate()) {
      String name = _examNameController.text;
      String examDate = _examDateController.text;
      String description = _examDescriptionController.text;

      // Save to `custom_exams` table
      await dbHelper.insertCustomExam(
        name: name,
        examDate: examDate,
        description: description,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam data saved!')));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Exam Name field
                TextFormField(
                  controller: _examNameController,
                  decoration: const InputDecoration(labelText: 'Exam Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the exam name';
                    }
                    return null;
                  },
                ),
                // Exam Date field
                TextFormField(
                  controller: _examDateController,
                  decoration: const InputDecoration(labelText: 'Exam Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the exam date';
                    }
                    return null;
                  },
                ),
                // Exam Description field
                TextFormField(
                  controller: _examDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                // Submit button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveExamData(); // Correctly call the method
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExamScheduleScreen()),
                    );
                  },
                  child: const Text('Add this Exam'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
