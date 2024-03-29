// Import necessary packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListScreen extends StatelessWidget {
  final String userId;
  final bool? showCompleted;

  const TaskListScreen({
    super.key,
    required this.userId,
    this.showCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos');

    if (showCompleted != null) {
      query = query.where('isDone', isEqualTo: showCompleted);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(showCompleted == null
            ? 'All Tasks'
            : (showCompleted! ? 'Completed Tasks' : 'Ongoing Tasks')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.error != null) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['title'] ?? 'No Title'),
                  subtitle: Text(data['description'] ?? 'No Description'),
                );
              }).toList(),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
