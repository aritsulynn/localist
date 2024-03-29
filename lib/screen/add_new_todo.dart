import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/model/todo.dart';

class AddNewTodo extends StatefulWidget {
  const AddNewTodo({super.key});

  @override
  State<AddNewTodo> createState() => _AddNewTodoState();
}

class _AddNewTodoState extends State<AddNewTodo> {
  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  String? errorMessage = '';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController isDoneController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  bool isButtonEnabled = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> addNewTodo() async {
    try {
      await Todo().addTodo(
        title: titleController.text,
        description: descriptionController.text,
        date: Timestamp.fromDate(DateTime.parse(dateController.text)),
        location: GeoPoint(
          double.parse(locationController.text.split(',')[0]), // lat
          double.parse(locationController.text.split(',')[1]), // lon
        ),
      );
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> pickDate() async {
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

  Widget _formAddTodo(BuildContext context) {
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
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Write a Short Description',
              filled: false,
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              filled: false,
              prefixIcon: Icon(Icons.date_range),
            ),
            readOnly: true,
            onTap: () {
              pickDate();
            },
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: "Location",
              filled: false,
              prefixIcon: Icon(Icons.location_on),
            ),
            onTap: () async {
              final selectedLocation =
                  await Navigator.pushNamed(context, '/map');
              if (selectedLocation != null) {
                setState(() {
                  String locationString = selectedLocation as String;
                  List<String> locationParts = locationString.split(',');
                  String lat = locationParts[0];
                  String lon = locationParts[1];
                  locationController.text = '$lat, $lon';
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                addNewTodo();
                Navigator.pop(context);
              } else {
                // print('Button is disabled');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _formAddTodo(context),
            ],
          ),
        ),
      ),
    );
  }
}
