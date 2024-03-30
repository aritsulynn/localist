import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:localist/screen/add_new_todo.dart';
import 'dart:developer' as developer;

class Todo {
  final db = FirebaseFirestore.instance;

  Future<void> addTodo({
    required String title,
    String? description,
    required Timestamp date,
    GeoPoint? location,
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
          'location': location,
        })
        .then((value) => developer.log("Todo Added"))
        .catchError((error) => developer.log("Failed to add todo: $error"));
  }

  // return all todos from firebase
  Stream<QuerySnapshot> getAllTodos() {
    return db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        // .orderBy('isDone', descending: false)
        // .where('date', isLessThan: DateTime.now())
        .snapshots();
  }

  // return db
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .collection('todos')
  //         .where('date', isLessThan: DateTime.now())
  //         .orderBy('date', descending: decending!)
  //         .snapshots();
  //   }

  Stream<QuerySnapshot> getAllTodos2(bool? descending, String? where) {
    Query<Map<String, dynamic>> query = db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos');

    switch (where) {
      case 'All':
        return query.orderBy('isDone', descending: descending!).snapshots();
      case 'Today':
        final today = DateTime.now().toUtc().subtract(
              Duration(
                hours: DateTime.now().hour,
                minutes: DateTime.now().minute,
                seconds: DateTime.now().second,
                milliseconds: DateTime.now().millisecond,
                microseconds: DateTime.now().microsecond,
              ),
            );
        final tomorrow = today.add(Duration(days: 1));

        return query
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(today),
              isLessThan: Timestamp.fromDate(tomorrow),
            )
            .orderBy('date')
            .orderBy('isDone', descending: descending!)
            .snapshots();
      case 'Upcoming':
        return query
            .where('date', isGreaterThan: DateTime.now())
            .orderBy('date')
            .orderBy('isDone', descending: descending!)
            .snapshots();
      case 'Overdue':
        return query
            .where('date', isLessThan: DateTime.now())
            .orderBy('date')
            .orderBy('isDone', descending: descending!)
            .snapshots();
      default:
        return query.orderBy('isDone', descending: descending!).snapshots();
    }
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

  Future<void> editTodo({
    required String docId,
    required String title,
    String? description,
    required Timestamp date,
    GeoPoint? location,
  }) async {
    await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(docId)
        .update({
          'title': title,
          'description': description,
          'date': date,
          'location': location,
        })
        .then((value) => developer.log("Todo Updated"))
        .catchError((error) => developer.log("Failed to update todo: $error"));
  }

  Future<DocumentSnapshot> getTodoDetail(String docId) async {
    return await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('todos')
        .doc(docId)
        .get();
  }
}
