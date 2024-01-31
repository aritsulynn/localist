import 'package:flutter/material.dart';
import 'package:localist/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/screen/register_login.dart';
import 'package:localist/widget_tree.dart';
import 'package:localist/screen/aboutus.dart';

class NavigationDrawerCustom extends StatelessWidget {
  const NavigationDrawerCustom({super.key});

  Future<void> signOut(BuildContext context) async {
    Navigator.popUntil(context, ModalRoute.withName('/')); // pop until root
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const WidgetTree(),
    ));
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
        color: Color.fromARGB(255, 187, 187, 187),
        image: DecorationImage(
          image: AssetImage('assets/icon/app_icon.png'),
          fit: BoxFit.fitHeight,
        ),
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
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
          },
        ),
        ListTile(
          // about us
          leading: const Icon(Icons.info),
          title: const Text('About us'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AboutUs(),
            ));
          },
        ),
        ListTile(
          // logout
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            signOut(context);
          },
        ),
      ],
    );
  }
}
