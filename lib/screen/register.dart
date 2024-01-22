import 'package:flutter/material.dart';
import 'package:localist/model/profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
            child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Email", style: TextStyle(fontSize: 20)),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (String email) {
                  profile.email = email;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text("Password", style: TextStyle(fontSize: 20)),
              TextFormField(
                obscureText: true,
                onSaved: (String password) {
                  profile.password = password;
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    formKey.currentState?.save();
                    print("email: $profile.email password: $profile.password");
                  },
                  child: Text("Register"),
                ),
              )
            ]),
          ),
        )),
      ),
    );
  }
}
