import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final Uri _url = Uri.parse('https://github.com/aritsulynn/localist/issues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "If you have any questions or need help, please contact us at:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () => setState(() {
                      launchUrl(_url, mode: LaunchMode.inAppWebView);
                    }),
                child: const Text("@localist on GitHub")),
          ],
        ),
      ),
    );
  }
}
