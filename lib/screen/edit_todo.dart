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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        'date': Timestamp.fromDate(DateTime.parse(dateController.text)),
        'location': locationController.text,
      });
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  String formatLocation(GeoPoint location) {
    return '${location.latitude}, ${location.longitude}';
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
      dateController.text =
          documentSnapshot['date'].toDate().toString().split(' ')[0];
      locationController.text = formatLocation(documentSnapshot['location']);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> pick_date() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        dateController.text = date.toString().split(' ')[0]; // get date only
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getTodoDetail();
  }

  Widget _formEditTodo(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              // filled: false,
              prefixIcon: Icon(Icons.title),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 150),
              labelText: 'Short Description',
              filled: false,
              prefixIcon: Icon(Icons.description),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              filled: false,
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => pick_date(),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              filled: false,
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo"),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                editTodo();
                Navigator.pop(context);
              } else {
                print('Button is disabled');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: _formEditTodo(context))),
    );
  }
}
