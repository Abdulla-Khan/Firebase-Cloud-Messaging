import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SignUpFunctions {
  static Future<void> signIn(
      String email, String password, String name, context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);

      if (credential.user!.uid.isNotEmpty) {
        await FirebaseMessaging.instance.getToken().then(
          (value) async {
            await FirebaseFirestore.instance.collection('Users').doc(name).set({
              'name': name,
              'email': credential.user!.email,
              'password': password,
              'token': value
            });
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Account Creation Succesfull'),
          backgroundColor: Colors.black.withOpacity(0.4),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('The password provided is too weak.'),
          backgroundColor: Colors.black.withOpacity(0.4),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('The account already exists for that email.'),
          backgroundColor: Colors.black.withOpacity(0.4),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
