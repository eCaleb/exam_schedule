import 'package:exam_schedule/screens/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faculty_dashboard.dart'; // Adjust import path as needed
 // Adjust import path as needed

class ScheduleViewScreen extends StatelessWidget {
  final CollectionReference exams = FirebaseFirestore.instance.collection('exams');
  final String role;

  ScheduleViewScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (role == 'faculty') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const FacultyDashboard()),
                (Route<dynamic> route) => false,
              );
            } else if (role == 'student') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StudentDashboard()),
                (Route<dynamic> route) => false,
              );
            }
            else {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamDetailsScreen(examId: exam.id, role: role),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
class ExamDetailsScreen extends StatelessWidget {
  final String examId;
  final String role;

  const ExamDetailsScreen({super.key, required this.examId, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exam Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('exams').doc(examId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final exam = snapshot.data;
          if (exam == null) {
            return const Text('Exam not found');
          }

          String courseName, date, time, location;
          try {
            courseName = exam['courseName'];
          } catch (e) {
            courseName = 'Course Name not found';
          }
          try {
            date = exam['date'];
          } catch (e) {
            date = 'Date not found';
          }
          try {
            time = exam['time'];
          } catch (e) {
            time = 'Time not found';
          }
          try {
            location = exam['location'];
          } catch (e) {
            location = 'Location not found';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5,),
                Text('Course Name: $courseName',style: const TextStyle(fontSize: 18),),
                const SizedBox(height: 20),
                Text('Date: $date',style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text('Time: $time',style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text('Location: $location',style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),

              ],
            ),
          );
        },
      ),
    );
  }
}