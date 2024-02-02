import 'package:flutter/material.dart';

// Authenication
import 'package:localist/screen/register_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/model/drawer.dart';

// TODO Things
import 'package:localist/model/todo.dart';
import 'package:localist/screen/add_new_todo.dart';
import 'package:localist/screen/edit_todo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  // const HomeScreen({super.key});

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
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _todotile2() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Todo().getAllTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No todos available.');
          } else {
            List<DocumentSnapshot> todos = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    todos[index].data() as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Dismissible(
                    key: Key(todos[index].id),
                    onDismissed: (direction) {
                      Todo().deleteTodo(
                        docId: todos[index].id,
                      );
                    },
                    background: Container(color: Colors.red),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                (EditScreen(docId: todos[index].id)),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.orange,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                  value: data['isDone'],
                                  side:
                                      BorderSide(color: Colors.white, width: 2),
                                  checkColor: Colors.white,
                                  activeColor: Colors.black,
                                  onChanged: (value) {
                                    Todo().updateTodoIsDone(
                                      docId: todos[index].id,
                                      isDone: value!,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                  data['title'].length > 15
                                      ? data['title'].substring(0, 20) + '...'
                                      : data['title'],
                                  style: TextStyle(
                                    color: data['isDone']
                                        ? Colors.black
                                        : Colors.white,
                                    decoration: data['isDone']
                                        ? TextDecoration.lineThrough
                                        : null,
                                  )),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
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
      appBar: AppBar(title: Text("All Todos")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _userUID(),
            // const Text("All Todos", style: TextStyle(fontSize: 20)),
            _todotile2(),
          ],
        ),
      ),
      floatingActionButton: _floatingAddButton(context),
      drawer: const NavigationDrawerCustom(),
    );
  }
}
