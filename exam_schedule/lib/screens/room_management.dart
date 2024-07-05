// room_management_screen.dart
import 'package:exam_schedule/screens/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomManagementScreen extends StatelessWidget {
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection('rooms');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()), // Navigate to your AdminDashboard
            );
          },
        ),
        title: const Text('Room Management',style:TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: rooms.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final roomDocs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: roomDocs.length,
            itemBuilder: (context, index) {
              final room = roomDocs[index];
              return ListTile(
                title: Text(room['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to edit room screen
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Delete room
                        rooms.doc(room.id).delete();
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddRoomScreen())); // Navigate to add room screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// add_room_screen.dart

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference rooms =
      FirebaseFirestore.instance.collection('rooms');

  void _addRoom() {
    final roomName = _nameController.text;

    rooms.add({
      'name': roomName,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Room',style:TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Room Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addRoom,
              child: const Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConflictResolutionScreen extends StatelessWidget {
  final CollectionReference exams =
      FirebaseFirestore.instance.collection('exams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()), // Navigate to your AdminDashboard
            );},),
        title: const Text('Conflict Resolution',style:TextStyle(fontWeight: FontWeight.bold)),
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
          // Logic for detecting conflicts
          return ListView.builder(
            itemCount: examDocs.length,
            itemBuilder: (context, index) {
              final exam = examDocs[index];
              return ListTile(
                title: Text(exam['courseName']),
                subtitle: Text('Date: ${exam['date']}'),
                trailing:
                    const Icon(Icons.warning, color: Colors.red), // Indicate conflict
                onTap: () {
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Room information not available'),
                            ),
                          ); // Navigate to detailed view for conflict resolution
                },
              );
            },
          );
        },
      ),
    );
  }
}
