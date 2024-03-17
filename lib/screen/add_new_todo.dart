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
  String _locationLabel = 'Location';
  bool isButtonEnabled = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> add_new_todo() async {
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

  Widget _errorMessage(BuildContext context) {
    if (errorMessage != '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    return Container(); // return empty container
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

  // Widget _entryField(String title, TextEditingController controller) {
  //   IconData? iconGen;
  //   if (title.toLowerCase() == "title") {
  //     iconGen = Icons.title;
  //   } else if (title.toLowerCase() == "description") {
  //     iconGen = Icons.description;
  //   } else if (title.toLowerCase() == "date") {
  //     iconGen = Icons.date_range;
  //   } else if (title.toLowerCase() == "location") {
  //     iconGen = Icons.location_on;
  //   } else {
  //     iconGen = Icons.error;
  //   }

  //   return TextField(
  //     controller: controller,
  //     decoration: InputDecoration(
  //       labelText: title,
  //       // errorText: controller.text.isEmpty ? 'This field is required' : null,
  //       filled: true,
  //       prefixIcon: Icon(iconGen),
  //       enabledBorder: const OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.grey),
  //       ),
  //       focusedBorder: const OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.black),
  //       ),
  //     ),
  //     readOnly: title.toLowerCase() == 'date' ? true : false,
  //     onTap: () {
  //       if (title.toLowerCase() == 'date') {
  //         pick_date();
  //       }
  //     },
  //     onChanged: (value) {
  //       setState(() {
  //         isButtonEnabled = titleController.text.isNotEmpty &&
  //             descriptionController.text.isNotEmpty &&
  //             dateController.text.isNotEmpty &&
  //             locationController.text.isNotEmpty;
  //       });
  //     },
  //   );
  // }

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
              // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 150),
              labelText: 'Short Description',
              filled: false,
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          // TextFormField(
          //   controller: tagController,
          //   decoration: const InputDecoration(
          //     labelText: 'Tag',
          //     filled: false,
          //     prefixIcon: Icon(Icons.tag),
          //   ),
          //   validator: (value) =>
          //       value!.isEmpty ? 'This field is required' : null,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              filled: false,
              prefixIcon: Icon(Icons.date_range),
            ),
            readOnly: true,
            onTap: () {
              pick_date();
            },
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: locationController,
            decoration: InputDecoration(
              labelText: _locationLabel, // Use a variable for the label text
              filled: false,
              prefixIcon: const Icon(Icons.location_on),
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
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
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
                add_new_todo();
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
          // margin:
          //     const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          // decoration: BoxDecoration(
          //   color: Colors.grey[300],
          //   borderRadius: BorderRadius.circular(16),
          // ),
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
