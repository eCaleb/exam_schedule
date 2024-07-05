import 'package:exam_schedule/screens/admin_dashboard.dart';
import 'package:exam_schedule/screens/edit_course.dart';
import 'package:exam_schedule/screens/faculty_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseManagementScreen extends StatelessWidget {
  final CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  final String role;

  CourseManagementScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (role == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
              );
            } else if (role == 'faculty') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FacultyDashboard()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Role not recognized'),
                ),
              );
            }
          },
        ),
        title: const Text('Course Management',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: courses.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final courseDocs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: courseDocs.length,
            itemBuilder: (context, index) {
              final course = courseDocs[index];
              return ListTile(
                title: Text(course['name']),
                subtitle: Text('Instructor: ${course['instructor']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditCourseScreen(course: course, role: role),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        courses.doc(course.id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddCourseScreen(role: role)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddCourseScreen extends StatefulWidget {
  final String role;

  AddCourseScreen({super.key, required this.role});

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructorController = TextEditingController();
  final CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  void _addCourse() async {
    final courseName = _nameController.text.trim();
    final instructorName = _instructorController.text.trim();

    if (courseName.isEmpty || instructorName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    await courses.add({
      'name': courseName,
      'instructor': instructorName,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CourseManagementScreen(
              role: widget.role)), // Pass role when navigating back
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: _addCourse,
              child: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}
