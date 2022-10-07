import 'package:flutter/material.dart';
import 'package:tttt/funtions/signup_functions.dart';
import 'package:tttt/views/components/text_feilds.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFE6DADA),
              Color.fromARGB(255, 119, 116, 116)
            ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: size.height / 2,
                  width: size.width / 1,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/login.gif'),
                          fit: BoxFit.cover)),
                ),
                EmailFeild(
                  controller: name,
                  label: 'Name',
                  isEmail: false,
                ),
                const SizedBox(height: 20),
                EmailFeild(
                  controller: email,
                  label: 'Email',
                  isEmail: true,
                ),
                const SizedBox(height: 20),
                PasswordFeild(controller: password),
                GestureDetector(
                  onTap: () async {
                    if (password.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        name.text.isNotEmpty) {
                      await SignUpFunctions.signIn(
                          email.text, password.text, name.text, context);

                      password.clear();
                      email.clear();
                      name.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Enter your credentials'),
                        backgroundColor: Colors.black.withOpacity(0.4),
                      ));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: size.width / 2,
                    height: size.height / 17,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text('Create Account',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 20))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an Account?",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginPage()));
                        },
                        child: Text('Login',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.9),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
