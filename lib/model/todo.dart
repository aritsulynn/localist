import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String title;
  final String description;
  final bool isDone;

  // final db = FirebaseFirestore.instance;

  Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Todo.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        description = map['description'],
        isDone = map['isDone'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  // Future<void> addTodo(require) async {
  //   CollectionReference todos = FirebaseFirestore.instance.collection('todos');
  //   todos
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('todos')
  //       .add({
  //         'title': title,
  //         'description': description,
  //         'isDone': isDone,
  //       })
  //       .then((value) => print("Todo Added"))
  //       .catchError((error) => print("Failed to add todo: $error"));
  // }

  // view todo
}
