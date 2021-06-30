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

  static List<Subtask> subtasks = [];
  //---------------------Delete Todos ---------------------------
  static deleteTodos(item) {
    DocumentReference delref = HomeReference.homeref.doc(item);

    delref.delete().whenComplete(() {
      // ignore: avoid_print
      print(" TODO - $item Deleted");
    });
  }
  //-------------------------------------------------------------

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
      // "subtask": subtasks.asMap()
    };

    docref.set(todos).whenComplete(() {
      // ignore: avoid_print
      print(" TODO $todoTitle created");
    });
  }
}

class Subtask {
  String? title;
  bool completed;

  Subtask({required this.title, required this.completed});
}
