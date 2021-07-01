import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_done/home/others/utils.dart';

class Functions {
  //----------------------Fields-------------------------------
  static String todoTitle = "";
  static String todoDescription = "";
  static String title = "";
  static String priority = "High";

  static prioritycolor(String p) {
    if (p == "High") {
      return Colors.red.value;
    } else if (p == "Medium") {
      return Colors.yellow.value;
    } else {
      return Colors.greenAccent.value;
    }
  }

  static deleteTodos(item) {
    DocumentReference delref = HomeReference.homeref.doc(item);

    delref.delete();
  }

  static deleteSubtasks(item) {
    DocumentReference delsref = HomeReference.subref.doc(item);

    delsref.delete();
  }

  static createTodos() {
    DocumentReference docref = HomeReference.homeref.doc();

    //Map
    Map<String, dynamic> todos = {
      "color": prioritycolor(priority),
      "todoTitle": todoTitle,
      "priority": priority,
      "date": FieldValue.serverTimestamp(),
      "isCompleted": false,
      "desc": todoDescription,
    };

    if (todoTitle.isEmpty) {
      return null;
    } else {
      return docref.set(todos);
    }
  }
}
