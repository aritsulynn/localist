import 'package:flutter/material.dart';
import 'dart:developer' as developer;
// Authenication
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:localist/model/auth.dart';

// TODO Things
import 'package:localist/model/todo.dart';
import 'package:localist/screen/add_new_todo.dart';
import 'package:localist/screen/edit_todo.dart';

enum SortOrder { ascending, descending }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});

  final db = FirebaseFirestore.instance;
  final User? user = Auth().currentUser;
  bool decending = false;
  String where = 'All';

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _todotile2() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Todo().getAllTodos2(decending, where),
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

                DateTime todoDate = (data['date'] as Timestamp).toDate();
                DateTime tomorrow = DateTime.now();
                Color subtitleColor =
                    todoDate.isBefore(tomorrow) ? Colors.red : Colors.black;
                // developer.log('Todo Date: $todoDate');
                // developer.log('Tomorrow: $tomorrow');
                return Container(
                  // margin: const EdgeInsets.only(bottom: 5),
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
                        color: Colors.white,
                        child: ListTile(
                          leading: Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              value: data['isDone'],
                              side: const BorderSide(
                                  color: Colors.grey, width: 2),
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
                          title: Text(
                            data['title'].length > 15
                                ? data['title'].substring(0, 20) + '...'
                                : data['title'],
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: data['isDone']
                                  ? const Color.fromARGB(255, 97, 97, 97)
                                  : Colors.black,
                              decoration: data['isDone']
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('E, MMM d, yyyy').format(todoDate),
                            style: TextStyle(color: subtitleColor),
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
        minimum: EdgeInsets.zero,
        bottom: false,
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
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    'assets/images/panda.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          );
        },
      ),
    );
  }

  SortOrder _currentSortOrder = SortOrder.ascending;

  Widget _sortButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          if (_currentSortOrder == SortOrder.ascending) {
            decending = true;
          } else {
            decending = false;
          }
          _currentSortOrder = _currentSortOrder == SortOrder.ascending
              ? SortOrder.descending
              : SortOrder.ascending;
        });
      },
      child: Row(
        children: [
          Text(
            'Sort by due date ',
            style: TextStyle(color: Colors.black),
          ),
          Icon(
            _currentSortOrder == SortOrder.ascending
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  // Widget _topButton() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: ['All', 'Today', 'Upcoming', 'Overdue'].map((filter) {
  //         return TextButton(
  //           onPressed: () => setState(() => where = filter),
  //           child: Text(
  //             filter,
  //             style: TextStyle(color: Colors.black),
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }
  Widget _topButton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['All', 'Today', 'Upcoming', 'Overdue'].map((filter) {
          bool isSelected = filter == where;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  where = filter;
                });
              },
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _topButton(),
            _sortButton(),
            _todotile2(),
          ],
        ),
      ),
      bottomNavigationBar: _buttomNavbar(),
    );
  }
}
