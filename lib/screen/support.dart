import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final Uri _url = Uri.parse('https://github.com/aritsulynn/localist/issues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity, // Takes the full width of the screen
        color: Colors.white, // Set background color to white
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Need help or have questions?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Maintaining black color for contrast
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Feel free to reach out to us on GitHub.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black
                    .withOpacity(0.6), // Slightly transparent black for subtext
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => launchUrl(_url, mode: LaunchMode.inAppWebView),
              icon: Icon(Icons.contact_support, color: Colors.black),
              label: const Text("@localist on GitHub",
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button color
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
                disabledBackgroundColor: Colors.grey
                    .withOpacity(0.12), // Button surface color on disabled
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
                side: BorderSide(
                    color: Colors.black,
                    width: 2), // Border to maintain B&W theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
