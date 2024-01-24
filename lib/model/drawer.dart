import 'package:flutter/material.dart';
import 'package:localist/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';

class NavigationDrawerCustom extends StatelessWidget {
  const NavigationDrawerCustom({super.key});

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
      ),
      child: Text(
        'Localist',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
          },
        ),
        ListTile(
          // about us
          leading: const Icon(Icons.info),
          title: const Text('About us'),
          onTap: () {},
        ),
        ListTile(
          // logout
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            signOut();
          },
        ),
      ],
    );
  }
}
