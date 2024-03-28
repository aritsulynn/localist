import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "If you have any questions or need help, please contact us at: @localist on GitHub.",
              style: TextStyle(fontSize: 20),
            ),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("https://google.com")),
              child: const Text(
                "@localist on GitHub",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),
            const Text("")
          ],
        ),
      ),
      // bottomNavigationBar: buildButton(),
    );
  }
}
