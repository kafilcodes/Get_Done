import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_done/services/others/utils.dart';

class HomeReference {
  static CollectionReference<Map<String, dynamic>> homeref = FirebaseFirestore
      .instance
      .collection("users")
      .doc(getuser.user!.uid)
      .collection("MyTodos");

  static CollectionReference<Map<String, dynamic>> subref =
      homeref.doc().collection("subtasks");
}
