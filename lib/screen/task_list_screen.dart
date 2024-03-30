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
        backgroundColor: Colors.black, // AppBar background color
        foregroundColor: Colors.white, // AppBar foreground color (title, icons)
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // Adding a linear gradient for a simple graphic effect
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade800, // Darker grey shade
                Colors.black, // Black color
              ],
              stops: [0.5, 1],
            ),
          ),
        ),
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

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return TaskCard(data: data);
              },
            );
          } else {
            return const Center(child: Text('No tasks available'));
          }
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TaskCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: 8),
            Text(
              data['description'] ?? 'No Description',
              style: TextStyle(
                  fontSize: 14, color: const Color.fromARGB(255, 65, 64, 64)),
            ),
          ],
        ),
      ),
    );
  }
}
