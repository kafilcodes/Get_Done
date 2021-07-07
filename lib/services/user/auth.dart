import 'package:firebase_auth/firebase_auth.dart'
    show AuthCredential, FirebaseAuth, GoogleAuthProvider, User, UserCredential;
import 'package:flutter/material.dart';
import 'package:get_done/handler/LoginPage.dart';
import 'package:get_done/home/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_support/overlay_support.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  FirebaseAuth auth = FirebaseAuth.instance;

  // ignore: non_constant_identifier_names
  Stream<String> get OnAuthStateChanged {
    return auth.authStateChanges().map((user) => user!.uid);
  }

  Future<String> currentUser() async {
    final User? user = await auth.currentUser;
    return user!.uid;
  }

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn().whenComplete(
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                ),
              );
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
        } catch (e) {
          showSimpleNotification(Text("${e.toString()}"),
              background: Colors.yellowAccent.withOpacity(0.8));
        }
      } else {
        showSimpleNotification(Text("NOT ABLE TO SIGN IN "),
            background: Colors.redAccent.withOpacity(0.8));
      }
    } catch (e) {
      showSimpleNotification(Text("${e.toString()}"));
    }
  }

  signOutUser(BuildContext context) async {
    await auth.signOut().whenComplete(
          () => Navigator.pop(context),
        );
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    await auth.currentUser!.reload().whenComplete(
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          ),
        );
  }
}
