import 'package:flutter/material.dart';
import 'package:localist/data/user_profile.dart';
import 'package:localist/model/image_dialog.dart';
import 'package:localist/model/numbers_widget.dart';
import 'package:localist/screen/edit_profile.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  final String? name;
  const MyProfile(this.name, {super.key});
  @override
  State<MyProfile> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfile> {
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
    final userProfile = Provider.of<UserProfile>(context);
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          userProfile.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'test123@gmail.com',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildNumberSection() {
    return NumberWidget();
  }

  Widget buildButton() {
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
            child: const Text('Edit Profile')),
      ),
    );
  }
}
