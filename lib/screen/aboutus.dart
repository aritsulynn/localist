import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.black, // AppBar background color
        foregroundColor: Colors.white, // AppBar foreground color (title, icons)
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // Adding a linear gradient for a simple graphic effect
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade800, // Darker grey shade
                Colors.black, // Black color
              ],
              stops: [0.5, 1],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Localist",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .grey[850]), // Slightly lighter than the AppBar
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Discover Localist",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87), // Soft black
              ),
              const SizedBox(height: 10),
              Text(
                "Localist is a powerful task management tool with a unique feature: it smoothly integrates map locations. Whether you're planning a journey or arranging daily tasks, Localist allows you to easily add, edit, and remove tasks to keep you organized.",
                style: TextStyle(
                    fontSize: 18,
                    color:
                        Colors.grey[600]), // Medium gray for better readability
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey[400]), // Decorative divider
              const SizedBox(height: 20),
              Text(
                "Built with Passion",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                "Localist was designed and developed using innovative technologies, utilizing the power of Flutter and Firebase to provide a seamless, efficient, and powerful experience.",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[400]),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/icon/Flutter_logo.png',
                    width: 100,
                  ),
                  Image.asset(
                    'assets/icon/Firebase_logo.png',
                    width: 140,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                  child: Text(
                "Powered by Flutter & Firebase",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 0, 0, 0)),
              )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
