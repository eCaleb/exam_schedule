import 'package:exam_schedule/screens/calendar.dart';
import 'package:exam_schedule/screens/login_screen.dart';
import 'package:exam_schedule/screens/notifications.dart';
import 'package:exam_schedule/screens/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard',style: TextStyle(fontWeight: FontWeight.bold),),
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
                leading: const Icon(Icons.schedule),
                title: const Text('Upcoming Exams'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleViewScreen(
                        role: 'student',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                onTap: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );  // Navigate to notifications screen
                },
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 5,
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('View Exam Calendar'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Calendar(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
