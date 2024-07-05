import 'package:exam_schedule/screens/course_management.dart';
import 'package:exam_schedule/screens/exam_management.dart';
import 'package:exam_schedule/screens/login_screen.dart';
import 'package:exam_schedule/screens/notifications.dart';
import 'package:exam_schedule/screens/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyDashboard extends StatelessWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Dashboard',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.book),
                title: const Text('Manage Courses'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseManagementScreen(role: 'faculty'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.event),
                title: const Text('Manage Exams'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamManagementScreen(role: 'faculty'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.schedule),
                title: const Text('View Exam Schedule'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleViewScreen(role: 'faculty'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              ); // Navigate to notifications screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
