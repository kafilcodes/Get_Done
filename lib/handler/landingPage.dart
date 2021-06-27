// ignore: file_names
import 'package:get_done/handler/LoginPage.dart';
import 'package:get_done/services/notifications/firebase_notification_handler.dart';
import 'package:get_done/home/Home.dart';

import 'package:get_done/services/others/error.dart';
import 'package:get_done/services/others/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: use_key_in_widget_constructors, file_names
class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseNotification firebaseNotification = new FirebaseNotification();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      firebaseNotification.setupFirebase(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        } else if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data as User?;

                if (user == null) {
                  return LoginPage();
                } else {
                  return Home();
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else if (snapshot.connectionState == ConnectionState.none) {
                return ErrorPage();
              }
              return ErrorPage();
            },
          );
        }
        return ErrorPage();
      },
    );
  }
}
