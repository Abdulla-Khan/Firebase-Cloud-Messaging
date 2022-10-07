import 'package:flutter/material.dart';
import 'package:tttt/views/components/text_feilds.dart';
import 'package:tttt/views/pages/sign-up.dart';

import '../../funtions/login_functions.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  void initState() {
    LoginMethods.checkLogin(context);
    // TODO: implement initState
    super.initState();
  }

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
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: size.height / 2,
                  width: size.width / 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/login.gif'),
                          fit: BoxFit.cover)),
                ),
                EmailFeild(
                  controller: email,
                  label: 'Email',
                  isEmail: true,
                ),
                SizedBox(height: 30),
                PasswordFeild(controller: password),
                GestureDetector(
                  onTap: () {
                    if (password.text.isNotEmpty && email.text.isNotEmpty) {
                      LoginMethods.login(email.text, password.text, context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Enter your credentials'),
                        backgroundColor: Colors.black.withOpacity(0.4),
                      ));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: size.width / 2,
                    height: size.height / 17,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text('Login',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 20))),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an Account?",
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
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => SignUp()));
                        },
                        child: Text('Create one',
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
