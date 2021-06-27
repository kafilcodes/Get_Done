import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static late BuildContext myContext;

  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = const AndroidInitializationSettings("notification_icon");
    var initIOS = const IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Get payload : $payload");
    }
  }

  static Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: myContext,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            isDefaultAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          )
        ],
      ),
    );
  }
}
