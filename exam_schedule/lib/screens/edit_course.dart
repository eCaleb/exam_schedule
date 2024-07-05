import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCourseScreen extends StatefulWidget {
  final DocumentSnapshot course;
  final String role;

  EditCourseScreen({required this.course, required this.role});

  @override
  _EditCourseScreenState createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController _nameController;
  late TextEditingController _instructorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course['name']);
    _instructorController = TextEditingController(text: widget.course['instructor']);
  }

  void _editCourse() async {
    final courseName = _nameController.text.trim();
    final instructorName = _instructorController.text.trim();

    if (courseName.isEmpty || instructorName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    await widget.course.reference.update({
      'name': courseName,
      'instructor': instructorName,
    });

    Navigator.pop(context); // Navigate back to the previous screen (CourseManagementScreen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: _instructorController,
              decoration: const InputDecoration(labelText: 'Instructor Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editCourse,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
