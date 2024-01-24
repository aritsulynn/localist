import 'package:firebase_auth/firebase_auth.dart';

class Todo {
  final String title;
  final String description;
  final bool isDone;

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
}
