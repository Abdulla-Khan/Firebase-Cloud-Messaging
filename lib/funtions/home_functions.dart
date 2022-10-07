import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tttt/views/pages/login.dart';

class HomeFunctions {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initInfo() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initialSetting = InitializationSettings(android: android);
    _notificationsPlugin.initialize(
      initialSetting,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails('tttt', 'tttt',
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

  static void sendMessage(token, String body, String title, context) async {
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static void request() async {
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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {}
  }

  static tap(
      String name, String title, String body, bool? value, context) async {
    if (name != '') {
      if (value!) {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("Users").get();
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i];
          HomeFunctions.sendMessage(a.get('token'), body, title, context);
        }
      } else {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('Users')
            .doc(name)
            .get();
        String token = snap.get('token');
        HomeFunctions.sendMessage(token, body, title, context);
      }
    }
  }

  static logOut(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.remove('login');
    await pref.remove('name');

    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }
}
