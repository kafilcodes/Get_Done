import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_handler.dart';

class FirebaseNotification {
  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  void dpnsubscribe() {
    _messaging.subscribeToTopic("DailyPushNotification").whenComplete(
        () => print("SUBSCRIBED TO DAILY PUSH PUSH NOTIFICATION"));
  }

  void dpnunsubscribe() {
    _messaging.unsubscribeFromTopic("DailyPushNotification").whenComplete(
        () => print("UN-SUBSCRIBED TO DAILY PUSH PUSH NOTIFICATION"));
  }

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("Settings ${settings.authorizationStatus}");
    //Get Token
    _messaging.getToken().then((token) => print("MY TOKEN  - $token"));
    //Subscribe to Topic
    _messaging
        .subscribeToTopic("demo")
        .whenComplete(() => print("Subsribed OK"));

    //Handle Message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print("Receive $remoteMessage");
      if (Platform.isAndroid)
        showNotification(
            remoteMessage.data["title"], remoteMessage.data["body"]);
      else if (Platform.isIOS)
        showNotification(remoteMessage.notification!.title,
            remoteMessage.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print("Receive open app : $remoteMessage");
      if (Platform.isIOS)
        showDialog(
          context: myContext,
          builder: (context) => CupertinoAlertDialog(
            title: Text(remoteMessage.notification!.title),
            content: Text(remoteMessage.notification!.body),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                isDefaultAction: true,
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            ],
          ),
        );
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = const AndroidNotificationDetails(
        "com.example.kcoding.get_done", "Notify Channel", "Description",
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);
    var ios = const IOSNotificationDetails();
    var platForm = NotificationDetails(android: androidChannel, iOS: ios);

    await NotificationHandler.flutterLocalNotificationsPlugin
        .show(0, title, body, platForm, payload: "My Payload");
  }
}
