import 'package:flutter/material.dart';
import 'package:localist/screen/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:localist/widget_tree.dart';
import 'package:firebase_database/firebase_database.dart';
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
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade500),
        useMaterial3: true,
      ),
      // home: HomeScreen(),
      home: const WidgetTree(),
    );
  }
}
