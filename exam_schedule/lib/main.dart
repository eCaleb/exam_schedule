import 'package:exam_schedule/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/admin_dashboard.dart';
import 'screens/faculty_dashboard.dart';
import 'screens/student_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam Scheduling App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/' : '/dashboard', // Set initial route based on user authentication
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(role: ''), // Default dashboard route, replace '' with actual role if needed
        '/admin_dashboard': (context) => AdminDashboard(),
        '/faculty_dashboard': (context) => const FacultyDashboard(),
        '/student_dashboard': (context) => StudentDashboard(),
        
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final String role;

  const DashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case 'admin':
        return AdminDashboard();
      case 'faculty':
        return const FacultyDashboard();
      case 'student':
        return StudentDashboard();
      default:
        return LoginScreen(); // Handle default case, such as no role or error
    }
  }
}
