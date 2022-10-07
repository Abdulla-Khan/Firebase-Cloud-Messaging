import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class EmailFeild extends StatelessWidget {
  const EmailFeild({
    Key? key,
    required this.controller,
    required this.label,
    required this.isEmail,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          cursorColor: Colors.white,
          cursorHeight: 20,
          cursorWidth: 3,
          controller: controller,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: label,
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          validator: isEmail
              ? EmailValidator(errorText: 'Not a valid Email')
              : RequiredValidator(errorText: 'Needs to be filled'),
        ),
      ),
    );
  }
}

class PasswordFeild extends StatefulWidget {
  PasswordFeild({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<PasswordFeild> createState() => _PasswordFeildState();
}

class _PasswordFeildState extends State<PasswordFeild> {
  bool see = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextFormField(
        cursorColor: Colors.white,
        cursorHeight: 20,
        cursorWidth: 3,
        controller: widget.controller,
        obscureText: see,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                see ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  see = !see;
                });
              },
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        validator: RequiredValidator(errorText: 'Required'),
      ),
    );
  }
}
