import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tttt/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  bool see = false;

  void login(String email, String password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.uid.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: password,
            obscureText: see,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(see ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      see = !see;
                    });
                  },
                ),
                labelText: 'Password'),
          ),
          ElevatedButton(
              onPressed: () {
                login(email.text, password.text, context);
              },
              child: Text('Login'))
        ],
      ),
    );
  }
}
