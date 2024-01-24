import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:localist/model/profile.dart';
import '../auth.dart';
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

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      keyboardType: title.toLowerCase() == 'email'
          ? TextInputType.emailAddress
          : TextInputType.text,
      obscureText: title.toLowerCase() == 'password',
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : "$errorMessage");
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
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
        appBar: AppBar(title: _title()),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _entryField('email', _controllerEmail),
              _entryField('password', _controllerPassword),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton()
            ],
          ),
        ));
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

