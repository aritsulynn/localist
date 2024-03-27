import 'package:flutter/material.dart';

// Authenication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/model/drawer.dart';

// TODO Things
import 'package:localist/model/todo.dart';
import 'package:localist/screen/add_new_todo.dart';
import 'package:localist/screen/edit_todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Dismissible(
                    key: Key(todos[index].id),
                    onDismissed: (direction) {
                      Todo().deleteTodo(
                        docId: todos[index].id,
                      );
                    },
                    direction: DismissDirection
                        .endToStart, // slide from right to delete
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                (EditTodo(docId: todos[index].id)),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.orange[400],
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
                                  side: const BorderSide(
                                      color: Colors.white, width: 2),
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

  Widget _buttomNavbar() {
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: SafeArea(
        minimum:
            EdgeInsets.zero, // Remove any margin on the left and right sides
        bottom: false, // Ensure bottom padding is zero
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          // color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addnewtodo');
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text("New list",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _topNavbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppBar(title: Text('Loading...'));
          }
          if (snapshot.error != null) {
            return AppBar(title: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return AppBar(title: Text('No data found'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return AppBar(
            title: Text("Welcome ${userData['username']}!" ?? 'N/A'),
            leading: IconButton(
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset(
                  'assets/images/panda.jpg',
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _topNavbar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _todotile2(),
          ],
        ),
      ),
      bottomNavigationBar: _buttomNavbar(),
    );
  }
}
