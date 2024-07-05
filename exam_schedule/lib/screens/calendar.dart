import 'package:exam_schedule/screens/schedule_view.dart';
import 'package:exam_schedule/screens/student_dashboard.dart'; // Ensure the correct import path
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('exams').get();
  final events = <DateTime, List<dynamic>>{};

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final dateStr = data['date'];
    DateTime? examDate;

    try {
      examDate = DateFormat('yyyy-MM-dd').parse(dateStr); // Ensure this matches Firestore date format
    } catch (e) {
      print('Error parsing date: $e');
    }

    if (examDate != null) {
      final eventDate = DateTime.utc(examDate.year, examDate.month, examDate.day);
      if (events[eventDate] == null) {
        events[eventDate] = [];
      }
      events[eventDate]?.add({
        'id': doc.id,
        'courseName': data['courseName'],
        'date': data['date'],
      });
    }
  }

  setState(() {
    _events = events;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Exam Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StudentDashboard()), // Ensure the correct import path
            );
          },
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 1, 1),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...(_events[_selectedDay] ?? []).map((event) {
                  return ListTile(
                    title: Text(event['courseName']),
                    subtitle: Text(event['date']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamDetailsScreen(
                            examId: event['id'],
                            role: '', // Pass the appropriate role if needed
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
