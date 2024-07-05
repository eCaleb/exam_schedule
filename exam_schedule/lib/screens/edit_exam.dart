import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_schedule/screens/exam_management.dart';

class EditExamScreen extends StatefulWidget {
  final DocumentSnapshot exam;
  final String role;

  EditExamScreen({required this.exam, required this.role});

  @override
  _EditExamScreenState createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  late TextEditingController _courseNameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(text: widget.exam['courseName']);
    _dateController = TextEditingController(text: widget.exam['date']);
    _timeController = TextEditingController(text: widget.exam['time']);
    _locationController = TextEditingController(text: widget.exam['location']);
  }

  void _editExam() async {
    final courseName = _courseNameController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final location = _locationController.text.trim();

    if (courseName.isEmpty || date.isEmpty || time.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    await widget.exam.reference.update({
      'courseName': courseName,
      'date': date,
      'time': time,
      'location': location,
    });

    // Navigate back to the appropriate dashboard based on role
    if (widget.role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } else if (widget.role == 'faculty') {
      Navigator.pushReplacementNamed(context, '/faculty_dashboard');
    } else {
      // Handle other cases or default navigation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExamManagementScreen(role: widget.role)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Exam', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editExam,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
