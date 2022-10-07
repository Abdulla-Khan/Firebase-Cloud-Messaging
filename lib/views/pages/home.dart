import 'package:flutter/material.dart';
import 'package:tttt/funtions/home_functions.dart';
import 'package:tttt/views/components/text_feilds.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.name});
  final String? name;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? value = false;

  @override
  void initState() {
    HomeFunctions.request();
    HomeFunctions.initInfo();
    super.initState();
  }

  TextEditingController nameC = TextEditingController();
  TextEditingController titleC = TextEditingController();
  TextEditingController bodyC = TextEditingController();

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
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFE6DADA),
              Color.fromARGB(255, 119, 116, 116)
            ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 30, top: 100),
                  width: 300,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${widget.name} ",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6)),
                      ),
                      Text(
                        "Ready to send notifications",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmailFeild(
                      controller: nameC,
                      label: 'Name',
                      isEmail: false,
                      hint: "Reciver's name",
                    ),
                    const SizedBox(height: 20),
                    EmailFeild(
                      controller: titleC,
                      label: 'Title',
                      isEmail: false,
                      hint: 'Title of Message',
                    ),
                    const SizedBox(height: 20),
                    EmailFeild(
                      controller: bodyC,
                      label: 'Body',
                      isEmail: false,
                      hint: 'Body of Message',
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (nameC.text.isNotEmpty &&
                            bodyC.text.isNotEmpty &&
                            titleC.text.isNotEmpty) {
                          nameC.clear();
                          bodyC.clear();
                          titleC.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Enter Required Data'),
                            backgroundColor: Colors.black.withOpacity(0.4),
                          ));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: size.width / 1.5,
                        height: size.height / 17,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text('Send Notification',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Send to Every User',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Checkbox(
                            activeColor: Colors.transparent,
                            checkColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            splashRadius: 0,
                            value: value,
                            onChanged: (value) {
                              setState(() {
                                this.value = value;
                              });
                            }),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent.withOpacity(0.4),
          onPressed: () {
            HomeFunctions.logOut(context);
          },
          child: const Icon(Icons.logout)),
    );
  }
}
