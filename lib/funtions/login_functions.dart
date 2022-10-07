import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/pages/home.dart';

class LoginMethods {
  static void checkLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString('login');
    String? name = pref.getString('name');

    print(val);
    if (val != null) {
      await FirebaseMessaging.instance.getToken().then((value) async {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(name)
            .update({'token': value})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
        Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
  }

  static void login(String email, String password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.uid.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        print(credential.user!.displayName);
        await pref.setString('login', credential.user!.uid);
        await pref.setString('name', credential.user!.displayName ?? "");
        await FirebaseMessaging.instance.getToken().then((value) async {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(credential.user!.displayName)
              .update({'token': value})
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wrong password provided for that user.')));
      }
    }
  }
}
