import 'package:flutter/material.dart';
// import 'package:localist/model/profile.dart';
import '../model/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Add this line
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('Localist', style: TextStyle(fontSize: 30));
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    IconData? iconData;
    bool isPassword = title.toLowerCase() == 'password';
    if (title.toLowerCase() == 'email') iconData = Icons.email;
    if (isPassword) iconData = Icons.lock;

    return TextFormField(
      controller: controller,
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: iconData != null ? Icon(iconData) : null,
      ),
      validator: (value) {
        // Add this block
        if (value == null || value.isEmpty) {
          return 'Please enter your $title';
        }
        return null;
      },
    );
  }

  Widget _errorMessage(BuildContext context) {
    if (errorMessage != '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    return Container(); // return empty container
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Check form validation
          isLogin
              ? signInWithEmailAndPassword()
              : createUserWithEmailAndPassword();
        }
      },
      style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all(const Size(double.infinity, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
                side: const BorderSide(color: Colors.lightBlue)),
          )),
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(isLogin ? "Don't have account?" : "Already have account?"),
        TextButton(
          onPressed: () {
            setState(() {
              // Clear error message when switching between forms
              errorMessage = '';
              // Toggle the form type
              isLogin = !isLogin;
            });
            // Clear the form fields if needed
            _controllerEmail.clear();
            _controllerPassword.clear();
            // If using a form key, you might also want to reset the form state
            // _formKey.currentState?.reset();
          },
          child: Text(
            isLogin ? 'Register' : 'Login',
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Form(
          // Wrap Column with Form and pass the _formKey
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Image.asset(
              //   'assets/images/cover.png',
              //   height: 40,
              // ),
              const Image(
                image: AssetImage('assets/icon/icon.png'),
                height: 100,
              ),
              // _title(),
              // Divider(),
              Text(isLogin ? "Hello again!" : "Register",
                  style: const TextStyle(fontSize: 30)),
              const Text("Welcome to Localist", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              _entryField('Email', _controllerEmail),
              _entryField('Password', _controllerPassword),
              _errorMessage(context),
              const SizedBox(height: 20),
              _submitButton(),
              _loginOrRegisterButton()
            ],
          ),
        ),
      ),
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Register"),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(30.0),
//       child: Container(
//           child: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text("Email", style: TextStyle(fontSize: 20)),
//             TextFormField(
//               keyboardType: TextInputType.emailAddress,
//               // onSaved: (String email) {
//               //   profile.email = email;
//               // },
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Text("Password", style: TextStyle(fontSize: 20)),
//             TextFormField(
//               obscureText: true,
//               // onSaved: (String password) {
//               //   profile.password = password;
//               // },
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // formKey.currentState?.save();
//                   // print("email: $profile.email password: $profile.password");
//                 },
//                 child: Text("Register"),
//               ),
//             )
//           ]),
//         ),
//       )),
//     ),
//   );
// }
