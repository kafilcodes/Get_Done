import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class getuser {
  static User? user = FirebaseAuth.instance.currentUser;
}

// ignore: camel_case_types
class date {
  static DateTime now = DateTime.now();
  static DateTime start = DateTime(now.year, now.month, now.day, 0, 0);
  static DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
}
// emulator -  7fd6c8aa-40d5-4815-b28d-0c14fc24b10f
