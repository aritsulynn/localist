import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final userCollection = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Editing'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter new username',
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter new bio',
              ),
              keyboardType: TextInputType.multiline,
              maxLines:
                  null, // Use null for multiline input that grows automatically
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.trim().isNotEmpty &&
                      currentUser != null) {
                    // Update both the username and bio in Firestore
                    await userCollection.doc(currentUser?.uid).update({
                      'username': _nameController.text.trim(),
                      'bio': _bioController.text
                          .trim(), // Add this line to update the bio
                    });
                    // Pop the navigation stack with the updated username and bio
                    Navigator.of(context).pop();
                  } else {
                    // Handle the case where the text field is empty or there is no user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Username and bio cannot be empty')),
                    );
                  }
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                ),
                child: const Text('Confirm editing'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
