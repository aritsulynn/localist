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

  bool isButtonEnabled = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> add_new_todo() async {
    // try {
    //   await db.collection('users').doc(user?.uid).collection('todos').add({
    //     'title': titleController.text,
    //     'description': descriptionController.text,
    //     'isDone': false,
    //   });
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
    try {
      await Todo().addTodo(
        title: titleController.text,
        description: descriptionController.text,
        date: Timestamp.fromDate(DateTime.parse(dateController.text)),
      );
      // date: DateTime.parse(dateController.text),
      // location: locationController.text);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Widget _errorMessage(BuildContext context) {
    if (errorMessage != '') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
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
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        dateController.text = date.toString().split(' ')[0]; // get date only
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller) {
    IconData? icon_gen;
    if (title.toLowerCase() == "title") {
      icon_gen = Icons.title;
    } else if (title.toLowerCase() == "description") {
      icon_gen = Icons.description;
    } else if (title.toLowerCase() == "date") {
      icon_gen = Icons.date_range;
    } else if (title.toLowerCase() == "location") {
      icon_gen = Icons.location_on;
    } else {
      icon_gen = Icons.error;
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        // errorText: controller.text.isEmpty ? 'This field is required' : null,
        filled: true,
        prefixIcon: Icon(icon_gen),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      readOnly: title.toLowerCase() == 'date' ? true : false,
      onTap: () {
        if (title.toLowerCase() == 'date') {
          pick_date();
        }
      },
      onChanged: (value) {
        setState(() {
          isButtonEnabled = titleController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty &&
              dateController.text.isNotEmpty &&
              locationController.text.isNotEmpty;
        });
      },
    );
  }

  Widget _formTest(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              filled: true,
              prefixIcon: Icon(Icons.title),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 150),
              labelText: 'Description',
              filled: true,
              prefixIcon: Icon(Icons.title),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'This field is required' : null,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Date',
              filled: true,
              prefixIcon: Icon(Icons.date_range),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            readOnly: true,
            onTap: () {
              pick_date();
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
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[400],
        ),
        child: Column(
          children: [
            _formTest(context),
            // _entryField('Title', titleController),
            // SizedBox(
            //   height: 10,
            // ),
            // _entryField('Description', descriptionController),
            // SizedBox(
            //   height: 10,
            // ),
            // _entryField('Date', dateController),
            // SizedBox(
            //   height: 10,
            // ),
            // _entryField('Location', descriptionController)
          ],
        ),
      ),
    );
  }
}
