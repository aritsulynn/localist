import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localist/screen/edit_profile.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfile> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  final double coverHeight = 280;
  final double profileHeight = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
          buildNumberSection(),
          _editProfileButton(),
          _settingButton(),
          _supportButton(),
        ],
      ),
      // bottomNavigationBar: buildButton(),
    );
  }

  Widget buildTop() {
    final top = coverHeight / 2;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.asset(
        'assets/images/cover.jpg',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileImage() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => const ImageDialog(),
        );
      },
      child: const CircleAvatar(
        radius: 100,
        backgroundImage: ExactAssetImage('assets/images/panda.jpg'),
      ),
    );
  }

  Widget buildContent() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the snapshot is still loading data, show a CircularProgressIndicator
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          // If the snapshot ran into an error, display it
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          // If the snapshot has no data, inform the user
          return const Center(child: Text('No data available'));
        }

        // If there is data, display the user information
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            const SizedBox(height: 20),
            Text(
              userData['username'] ??
                  'N/A', // Provide a fallback if the username is null
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              userData['email'] ??
                  'N/A', // Provide a fallback if the email is null
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              userData['bio'] ?? 'N/A', // Provide a fallback if the bio is null
              textAlign: TextAlign.center, // Center the text (horizontally)
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget buildNumberSection() {
    return const NumberWidget();
  }

  Widget _editProfileButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const EditProfile(),
              ),
            );
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
          child: const Text('Edit Profile'),
        ),
      ),
    );
  }

  Widget _settingButton() {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.of(context).pushNamed('/setting');
      },
    );
  }

  Widget _supportButton() {
    return IconButton(
      icon: const Icon(Icons.help),
      onPressed: () {
        Navigator.of(context).pushNamed('/support');
      },
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.asset(
        'assets/images/panda.jpg',
        width: 400,
        height: 400,
        fit: BoxFit.cover,
      ),
    );
  }
}

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key});

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(text: 'TOTAL', value: 12),
        buildDivider(),
        buildButton(text: 'ONGOING', value: 3),
        buildDivider(),
        buildButton(text: 'COMPLETED', value: 9),
      ],
    );
  }

  Widget buildButton({required String text, required int value}) {
    return MaterialButton(
        onPressed: () {},
        padding: const EdgeInsets.symmetric(vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ));
  }

  Widget buildDivider() {
    return Container(
      height: 0, // Adjust the height to fit your design
      width: 1, // This will be the thickness of the divider
      color: Colors.grey, // Choose a color that fits your app's theme
      margin: const EdgeInsets.symmetric(
          horizontal: 12), // Add some spacing on both sides
    );
  }
}
