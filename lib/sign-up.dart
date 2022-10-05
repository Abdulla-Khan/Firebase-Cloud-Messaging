import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tttt/login.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  String? mtoken = '';

  Future<void> signIn(String email, String password, String name) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);

      print(credential.user!.displayName);

      if (credential.user!.uid.isNotEmpty) {
        await FirebaseMessaging.instance.getToken().then(
          (value) async {
            setState(() {
              mtoken = value;
              print('Token is $mtoken');
            });
            await FirebaseFirestore.instance.collection('Users').doc(name).set({
              'name': name,
              'email': credential.user!.email,
              'password': password,
              'token': value
            });
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: 'email'),
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(labelText: 'password'),
          ),
          ElevatedButton(
              onPressed: () {
                signIn(email.text, password.text, name.text);
              },
              child: Text('SignUp')),
        ],
      ),
    );
  }
}
