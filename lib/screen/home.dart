import 'package:flutter/material.dart';
import 'package:localist/screen/register_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/model/drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text("Localist");
  }

  Widget _userUID() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text("Sign Out"));
  }

  Widget _floatingAddButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: const Color.fromARGB(255, 255, 210, 75),
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   padding: const EdgeInsets.all(20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       _userUID(),
      //       _signOutButton(),
      //     ],
      //   ),
      // ),

      floatingActionButton: _floatingAddButton(),
      drawer: const NavigationDrawerCustom(),
    );
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("Localist"),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
  //       child: Column(
  //         children: [
  //           SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton.icon(
  //                   onPressed: () {
  //                     Navigator.push(context,
  //                         MaterialPageRoute(builder: (context) {
  //                       return RegisterScreen();
  //                     }));
  //                   },
  //                   icon: Icon(Icons.add),
  //                   label: Text(
  //                     "Register",
  //                     style: TextStyle(fontSize: 20),
  //                   ))),
  //           SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton.icon(
  //                   onPressed: () {
  //                     Navigator.push(context,
  //                         MaterialPageRoute(builder: (context) {
  //                       return LoginScreen();
  //                     }));
  //                   },
  //                   icon: Icon(Icons.login),
  //                   label: Text(
  //                     "Login",
  //                     style: TextStyle(fontSize: 20),
  //                   )))
  //         ],
  //       ),
  //     ),
  //   );
  // }
