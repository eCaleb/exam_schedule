import 'package:exam_schedule/screens/course_management.dart';
import 'package:exam_schedule/screens/exam_management.dart';
import 'package:exam_schedule/screens/login_screen.dart';
import 'package:exam_schedule/screens/reporting.dart';
import 'package:exam_schedule/screens/room_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',style: TextStyle(fontWeight: FontWeight.bold),),
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
                      builder: (context) => CourseManagementScreen(role: 'admin'),
                    ),
                  );
                },
              ),
            ),
           const SizedBox(height: 30,),
            Card(
               elevation: 5,
              child: ListTile(
                leading: Icon(Icons.event),
                title: const Text('Manage Exams'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExamManagementScreen(role: 'admin'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30,),
            Card(
               elevation: 5,
              child: ListTile(
                leading: Icon(Icons.room),
                title: const Text('Manage Rooms'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomManagementScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30,),
            Card(
               elevation: 5,
              child: ListTile(
                leading: Icon(Icons.report_problem),
                title: const Text('Conflict Resolution'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConflictResolutionScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30,),
            Card(
               elevation: 5,
              child: ListTile(
                leading: Icon(Icons.analytics),
                title: const Text('Reports and Analytics'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportingScreen(),
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
