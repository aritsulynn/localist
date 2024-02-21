import 'package:flutter/material.dart';
import 'package:localist/data/user_profile.dart';
import 'package:localist/screen/myprofile.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Editing'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Name',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final userProfileProvider =
                        Provider.of<UserProfile>(context, listen: false);
                    userProfileProvider.name = _name.text;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                      shadowColor: Colors.black,
                      elevation: 5,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10)),
                  child: const Text('Confirm editing'),
                ),
              ),
            )
          ],
        ));
  }
}
