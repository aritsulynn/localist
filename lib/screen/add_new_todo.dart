import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';

class AddNewTodo extends StatefulWidget {
  const AddNewTodo({super.key});

  @override
  State<AddNewTodo> createState() => _AddNewTodoState();
}

class _AddNewTodoState extends State<AddNewTodo> {
  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController isDoneController = TextEditingController();

  Future<void> add_new_todo() async {
    try {
      await db.collection('users').doc(user?.uid).collection('todos').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'isDone': false,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
      ),
      body: Container(
        child: Column(children: [
          _entryField('Title', titleController),
          _entryField('Description', descriptionController),
          ElevatedButton(
            onPressed: () {
              add_new_todo();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ]),
      ),
    );
  }
}
