import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localist/main.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/screen/edit_profile.dart';
import 'package:localist/model/todo.dart';

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

  Future<void> signOut(BuildContext context) async {
    Navigator.popUntil(context, ModalRoute.withName('/')); // pop until root
    Navigator.pushNamed(context, '/');
    await Auth().signOut();
  }

  Future<int> _getTaskCount(bool isCompleted) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId',
            isEqualTo:
                currentUser.uid) // Assuming tasks are filtered by user ID
        .where('isDone', isEqualTo: isCompleted)
        .get();

    return querySnapshot.docs.length;
  }

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
          const SizedBox(height: 20),
          _editProfileButton(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _settingButton(),
              _aboutButton(),
              _supportButton(),
              _logoutButton(),
            ],
          ),
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
    return StreamBuilder<QuerySnapshot>(
      stream: Todo().getAllTodos(),
      builder: (context, snapshot) {
        int totalTasks = 0;
        int completedTasks = 0;
        int ongoingTasks = 0;

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          totalTasks = snapshot.data!.docs.length;
          completedTasks =
              snapshot.data!.docs.where((doc) => doc['isDone'] as bool).length;
          ongoingTasks = totalTasks - completedTasks;
        }

        return NumberWidget(
          totalTasks: totalTasks,
          ongoingTasks: ongoingTasks,
          completedTasks: completedTasks,
          onTotalTap: () {
            Navigator.pushNamed(
              context,
              '/tasklistscreen',
              arguments: TaskListArguments(userId: currentUser.uid),
            );
          },
          onOngoingTap: () {
            Navigator.pushNamed(
              context,
              '/tasklistscreen',
              arguments: TaskListArguments(
                  userId: currentUser.uid, showCompleted: false),
            );
          },
          onCompletedTap: () {
            Navigator.pushNamed(
              context,
              '/tasklistscreen',
              arguments: TaskListArguments(
                  userId: currentUser.uid, showCompleted: true),
            );
          },
        );
      },
    );
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

  Widget _aboutButton() {
    return IconButton(
      icon: const Icon(Icons.info),
      onPressed: () {
        Navigator.of(context).pushNamed('/aboutus');
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

  Widget _logoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        signOut(context);
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
  final int totalTasks;
  final int ongoingTasks;
  final int completedTasks;
  final VoidCallback onTotalTap;
  final VoidCallback onOngoingTap;
  final VoidCallback onCompletedTap;

  const NumberWidget({
    super.key,
    required this.totalTasks,
    required this.ongoingTasks,
    required this.completedTasks,
    required this.onTotalTap,
    required this.onOngoingTap,
    required this.onCompletedTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // Ensuring the dividers have the same height as buttons
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: buildButton(
              text: 'TOTAL',
              value: totalTasks,
              onTap: onTotalTap,
            ),
          ),
          buildDivider(),
          Expanded(
            child: buildButton(
              text: 'ONGOING',
              value: ongoingTasks,
              onTap: onOngoingTap,
            ),
          ),
          buildDivider(),
          Expanded(
            child: buildButton(
              text: 'COMPLETED',
              value: completedTasks,
              onTap: onCompletedTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton({
    required String text,
    required int value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
