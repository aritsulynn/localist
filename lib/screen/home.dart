import 'package:flutter/material.dart';
import 'package:localist/screen/register_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/model/drawer.dart';
import 'package:localist/model/todo.dart';
import 'package:localist/screen/add_new_todo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _test() {
    return Text(user?.uid ?? 'User UID');
  }

  Widget _title() {
    return const Text("Localist");
  }

  Widget _userUID() {
    return Text(user?.uid ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text("Sign Out"));
  }

  Widget _floatingAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewTodo()),
        );
      },
      backgroundColor: const Color.fromARGB(255, 255, 210, 75),
      child: const Icon(Icons.add),
    );
  }

  Widget _todotile() {
    return const Column(
      children: [
        ListTile(
          title: Text('ListTile with red background'),
          tileColor: Colors.blue,
        ),
        ListTile(
          title: Text('ListTile with red background'),
          tileColor: Colors.black38,
        ),
      ],
    );
  }

  Widget _todotile2() {
    // return all todos from firebase
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('users')
            .doc(user?.uid)
            .collection('todos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No todos available.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Container(
                  color: ds['isDone'] ? Colors.grey : Colors.white,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ds['title'].length > 15
                            ? ds['title'].substring(0, 20) + '...'
                            : ds['title']),
                        SizedBox(width: 10), // Adjust the spacing as needed
                        Checkbox(
                          value: ds[
                              'isDone'], // You need a field in your data for the checkbox state
                          onChanged: (bool? value) {
                            // Handle checkbox change here
                            // You might want to update the 'completed' field in your Firestore document
                            db
                                .collection('users')
                                .doc(user?.uid)
                                .collection('todos')
                                .doc(ds.id)
                                .update({
                              'isDone': value,
                            });
                          },
                        ),
                      ],
                    ),
                    // You can add more fields if needed, e.g., subtitle, onTap, etc.
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _userUID(),
            _todotile2(),
          ],
        ),
      ),
      floatingActionButton: _floatingAddButton(context),
      drawer: const NavigationDrawerCustom(),
    );
  }
}
