import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localist/screen/add_new_todo.dart';

class Todo {
  final db = FirebaseFirestore.instance;

  Future<void> addTodo({
    required String title,
    required String description,
    required Timestamp date,
    // required GeoPoint location,
  }) async {
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .add({
          'title': title,
          'description': description,
          'isDone': false,
          'date': date,
          // 'location': location,
        })
        .then((value) => print("Todo Added"))
        .catchError((error) => print("Failed to add todo: $error"));
  }

  // return all todos from firebase
  Stream<QuerySnapshot> getAllTodos() {
    return db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .snapshots();
  }

  // change checkbox to done
  Future<void> updateTodoIsDone({
    required String docId,
    required bool isDone,
  }) async {
    // print(isDone);
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(docId)
        .update({'isDone': isDone})
        .then((value) => print("Todo Updated"))
        .catchError((error) => print("Failed to update todo: $error"));
  }

  Future<void> deleteTodo({
    required String docId,
  }) async {
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(docId)
        .delete()
        .then((value) => print("Todo Deleted"))
        .catchError((error) => print("Failed to delete todo: $error"));
  }

  // Future<String> getTodoTitle(String docId) async {
  //   String title = '';
  //   await db
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection('todos')
  //       .doc(docId)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       title = documentSnapshot.get('title');
  //     } else {
  //       print('Document does not exist on the database');
  //     }
  //   });
  //   return title.length > 15 ? (title.substring(0, 15) + '...') : title;
  // }
}
