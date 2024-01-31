import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About us'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Localist", style: TextStyle(fontSize: 40)),
              SizedBox(height: 20),
              Text(
                "Localist is a simple todo app that allows you to add, edit, and delete your todos. It is built using Flutter and Firebase.",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
