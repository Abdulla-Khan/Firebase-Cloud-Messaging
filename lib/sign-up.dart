import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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

      if (credential.user!.uid.isNotEmpty) {
        await FirebaseMessaging.instance.getToken().then(
          (value) async {
            setState(() {
              mtoken = value;
              print('Token is $mtoken');
            });
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(credential.user!.uid)
                .set({
              'name': name,
              'email': email,
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
          ElevatedButton(
              onPressed: () {
                getDocs();
              },
              child: Text('SignUp'))
        ],
      ),
    );
  }

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      List c = [];
      c.add(a.get('token'));
      print(c);
    }
  }
}
