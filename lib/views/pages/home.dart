import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tttt/views/components/text_feilds.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? value = false;

  @override
  void initState() {
    request();
    getToken();
    initInfo();
    super.initState();
  }

  String? mtoken = '';
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController nameC = TextEditingController();
  TextEditingController titleC = TextEditingController();
  TextEditingController bodyC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        print('tappd');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EmailFeild(
            controller: nameC,
            label: 'Name',
            isEmail: false,
            hint: "Reciver's name",
          ),
          SizedBox(height: 20),
          EmailFeild(
            controller: titleC,
            label: 'Title',
            isEmail: false,
            hint: 'Title of Message',
          ),
          SizedBox(height: 20),
          EmailFeild(
            controller: bodyC,
            label: 'Body',
            isEmail: false,
            hint: 'Body of Message',
          ),
          GestureDetector(
            onTap: () async {
              String name = nameC.text.trim();
              String title = titleC.text;
              String body = bodyC.text;
              List c = [];

              if (name != '') {
                if (value!) {
                  print('to everyone');
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection("Users")
                      .get();
                  for (int i = 0; i < querySnapshot.docs.length; i++) {
                    var a = querySnapshot.docs[i];
                    sendMessage(a.get('token'), body, title);
                  }
                } else {
                  print('chapaaa running');

                  DocumentSnapshot snap = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(name)
                      .get();
                  String token = snap.get('token');
                  print(snap.get('token'));
                  sendMessage(token, body, title);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.all(20),
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Checkbox(
              value: this.value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                });
                print(value);
              })
        ],
      ),
    ));
  }

  void request() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('============= GRANTED=============');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('============= Provisional=============');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
      (value) {
        setState(() {
          mtoken = value;
          print('Token is $mtoken');
        });
        // saveToken(value!);
      },
    );
  }

  // Future getDocs() async {

  //     print(c);
  //   }
  // }

  // void saveToken(String token) async {
  //   await FirebaseFirestore.instance
  //       .collection('UserTokens')
  //       .doc('User2')
  //       .set({'token': token});
  // }

  initInfo() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialSetting = InitializationSettings(android: android);
    _notificationsPlugin.initialize(
      initialSetting,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('=============Message=============');
      print('onMessage: ${message.notification?.title}');
      print('onMessage: ${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification?.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('tttt', 'tttt',
              importance: Importance.max,
              priority: Priority.max,
              playSound: false);

      NotificationDetails details =
          NotificationDetails(android: androidNotificationDetails);
      await _notificationsPlugin.show(0, message.notification?.title.toString(),
          message.notification?.body.toString(), details,
          payload: message.data['title']);
    });
  }

  void sendMessage(token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAABTZiz20:APA91bFnh84sTj3QD-Pmjo9Q14rFwwKdbhGR-eCkrpH0uqBygwYaHoZggxDHweLzTYe5CiKN0_hIQ8sA91bDJF9tEx7H1L9zxaZfBCcwkg0fZtsZqAGApgyKi_uK2YRwFVeqnwv0RwOW',
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              "android_channel_id": 'tttt'
            },
            "to": token
          }));
    } catch (e) {
      print("=========================$e+++++++++++++++++++=++++++++");
    }
  }
}
