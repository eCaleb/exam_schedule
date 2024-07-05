import 'package:exam_schedule/screens/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportingScreen extends StatelessWidget {
  final CollectionReference exams = FirebaseFirestore.instance.collection('exams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()), // Navigate to your AdminDashboard
            );
          },
        ),
        title: const Text('Reports and Analytics',style:TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: exams.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final examDocs = snapshot.data?.docs ?? [];
          // Generate reports and analytics data
          return ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final exam = examDocs[index];
              String? room = (exam.data() as Map<String, dynamic>?)?.containsKey('room') == true? exam['room'] : null;

              return ListTile(
                title: Text(exam['courseName']),
                subtitle: Text('Date: ${exam['date']}'),
                trailing: Text('Room: $room'),
              );
            },
          );
        },
      ),
    );
  }
}
