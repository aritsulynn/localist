import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _auth.currentUser?.providerData.first;
      await _auth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> _deleteAccount() async {
    try {
      // Get the currently signed-in user
      final User? user = _auth.currentUser;

      if (user != null) {
        // Show a confirmation dialog
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 20, 20, 20),
              title: const Text('Delete Account',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              content: const Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Color.fromARGB(255, 160, 29, 29)),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmDelete) {
          // Delete the user account
          await _reauthenticateAndDelete();
          Navigator.popUntil(context, ModalRoute.withName('/'));
          // Optionally, you can navigate to a different page or perform additional actions
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully.'),
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _deleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
