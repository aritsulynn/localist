import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';

class EditScreen extends StatefulWidget {
  final String docId;
  const EditScreen({super.key, required this.docId});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;

  String? errorMessage = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  Future<void> editTodo() async {
    try {
      await db
          .collection('users')
          .doc(user?.uid)
          .collection('todos')
          .doc(widget.docId)
          .update({
        'title': titleController.text,
        'description': descriptionController.text,
        'date': DateTime.parse(dateController.text),
        'location': locationController.text,
      });
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> getTodoDetail() async {
    try {
      DocumentSnapshot documentSnapshot = await db
          .collection('users')
          .doc(user?.uid)
          .collection('todos')
          .doc(widget.docId)
          .get();
      titleController.text = documentSnapshot['title'];
      descriptionController.text = documentSnapshot['description'];
      dateController.text = documentSnapshot['date'].toString();
      locationController.text = documentSnapshot['location'];
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Edit Todo")),
        body: Container(
          child: Column(
            children: [
              // Edit the task title, description, date, and location
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Description",
                ),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "Date",
                ),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Location",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  editTodo();
                  Navigator.pop(context);
                },
                child: Text("Edit"),
              ),
            ],
          ),
        ));
  }
}
