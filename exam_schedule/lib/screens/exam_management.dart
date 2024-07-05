import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_exam.dart'; // Adjust import path as needed
import 'admin_dashboard.dart'; // Adjust import path as needed
import 'faculty_dashboard.dart'; // Adjust import path as needed

class ExamManagementScreen extends StatelessWidget {
  final CollectionReference exams = FirebaseFirestore.instance.collection('exams');
  final String role;

  ExamManagementScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Management',style:TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (role == 'admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboard()),
                (Route<dynamic> route) => false, // Navigate to your AdminDashboard
              );
            } else if (role == 'faculty') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const FacultyDashboard()), 
                (Route<dynamic> route) => false,// Navigate to your FacultyDashboard
              );
            } else {
              // Handle other roles or edge cases
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Role not recognized'),
                ),
              );
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: exams.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final examDocs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final exam = examDocs[index];
              return ListTile(
                title: Text(exam['courseName']),
                subtitle: Text('Date: ${exam['date']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditExamScreen(exam: exam, role: role),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        exams.doc(exam.id).delete();
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
            MaterialPageRoute(builder: (context) => AddExamScreen(role: role)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class AddExamScreen extends StatefulWidget {
  final String role;

  AddExamScreen({required this.role});

  @override
  _AddExamScreenState createState() => _AddExamScreenState();
}

class _AddExamScreenState extends State<AddExamScreen> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(); // New controller for time
  final TextEditingController _locationController = TextEditingController();
  final CollectionReference exams = FirebaseFirestore.instance.collection('exams');
  final CollectionReference courses = FirebaseFirestore.instance.collection('courses');

  void _addExam() async {
    final courseName = _courseNameController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim(); // Retrieve time from the controller
    final location = _locationController.text.trim();

    if (courseName.isEmpty || date.isEmpty || time.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    // Fetch the instructor name based on the course name
    final querySnapshot = await courses.where('name', isEqualTo: courseName).get();
    if (querySnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course not found')),
      );
      return;
    }

    await exams.add({
      'courseName': courseName,
      'date': date,
      'time': time, // Add time to Firestore
      'location': location,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ExamManagementScreen(role: widget.role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam',style:TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ExamManagementScreen(role: widget.role)),
            );
          },
        ),
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
              onPressed: _addExam,
              child: const Text('Add Exam'),
            ),
          ],
        ),
      ),
    );
  }
}
