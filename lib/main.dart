import 'package:flutter/material.dart';
import 'package:localist/model/auth.dart';
import 'package:localist/screen/aboutus.dart';
import 'package:localist/screen/add_new_todo.dart';
import 'package:localist/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:localist/screen/register_login.dart';
import 'package:localist/screen/myprofile.dart';
import 'package:localist/screen/search.dart';
import 'package:localist/screen/setting.dart';
import 'package:localist/screen/support.dart';
import 'package:localist/screen/task_list_screen.dart';
import 'firebase_options.dart';

// test
import 'package:localist/screen/map.dart';
// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final storage = FirebaseStorage.instance;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localist',
      debugShowCheckedModeBanner: false, // remove debug banner
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder(
              stream: Auth().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return HomeScreen();
                } else {
                  return const RegisterScreen();
                }
              },
            ),
        '/addnewtodo': (context) => const AddNewTodo(),
        '/profile': (context) => const MyProfile(),
        '/aboutus': (context) => const AboutUs(),
        '/map': (context) => const MapSelection(),
        '/search': (context) => const SearchTodo(),
        '/setting': (context) => const SettingPage(),
        '/support': (context) => const Support(),
      },
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/tasklistscreen') {
          final args = settings.arguments as TaskListArguments;
          return MaterialPageRoute(
            builder: (context) => TaskListScreen(
              userId: args.userId,
              showCompleted: args.showCompleted,
            ),
          );
        }
        // If the route name does not match any predefined paths,
        // return null or define a default behavior
        return null;
      },
    );
  }
}

class TaskListArguments {
  final String userId;
  final bool? showCompleted;

  TaskListArguments({required this.userId, this.showCompleted});
}
