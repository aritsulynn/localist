import 'package:firebase_core/firebase_core.dart';
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
  final formKey = GlobalKey<FormState>();

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
    return const Text('Localist');
  }

  // Widget _entryField(
  //   String title,
  //   TextEditingController controller,
  // ) {
  //   return TextField(
  //     controller: controller,
  //     keyboardType: title.toLowerCase() == 'email'
  //         ? TextInputType.emailAddress
  //         : TextInputType.text,
  //     obscureText: title.toLowerCase() == 'password',
  //     decoration: InputDecoration(
  //       labelText: title,
  //     ),
  //   );
  // }
  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    IconData? iconData;

    if (title.toLowerCase() == 'email') iconData = Icons.email;
    if (title.toLowerCase() == 'password') iconData = Icons.lock;

    return TextField(
      controller: controller,
      keyboardType: title.toLowerCase() == 'Email'
          ? TextInputType.emailAddress
          : TextInputType.text,
      obscureText: title.toLowerCase() == 'password',
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: iconData != null ? Icon(iconData) : null,
      ),
    );
  }

  // Widget _errorMessage() {
  //   return Text(errorMessage == '' ? '' : "$errorMessage");
  // }
  Widget _errorMessage(BuildContext context) {
    if (errorMessage != '') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage!),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
    return Container(); // Return an empty container in the widget tree
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
                side: BorderSide(color: Colors.lightBlue)),
          )),
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
            isLogin ? '''Don't have account?''' : 'Already have account?'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: _title(),
      //   // backgroundColor: Colors.deepPurple,
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   'assets/images/cover.png',
            //   height: 40,
            // ),
            Text("Login", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(context),
            SizedBox(height: 20),
            _submitButton(),
            _loginOrRegisterButton()
          ],
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

