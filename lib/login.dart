import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tttt/home.dart';
import 'package:tttt/sign-up.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  String? mtoken = '';

  bool see = false;

  @override
  void initState() {
    checkLogin(context);
    // TODO: implement initState
    super.initState();
  }

  void checkLogin(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString('login');
    String? name = pref.getString('name');

    print(val);
    if (val != null) {
      await FirebaseMessaging.instance.getToken().then((value) async {
        setState(() {
          mtoken = value;
          print('Token is $mtoken');
        });
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

  void login(String email, String password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user!.uid.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        print(credential.user!.displayName);
        await pref.setString('login', credential.user!.uid);
        await pref.setString('name', credential.user!.displayName ?? "");
        await FirebaseMessaging.instance.getToken().then((value) async {
          setState(() {
            mtoken = value;
            print('Token is $mtoken');
          });
          FirebaseFirestore.instance
              .collection('Users')
              .doc(credential.user!.displayName)
              .update({'token': value})
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomePage()));
        });
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
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUp()));
              },
              child: Text(
                'Create Account',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
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
