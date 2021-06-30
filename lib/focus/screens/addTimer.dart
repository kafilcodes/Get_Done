import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_done/home/others/functions.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:get_done/services/others/utils.dart';
import 'package:google_fonts/google_fonts.dart';

CollectionReference ref = FirebaseFirestore.instance
    .collection("users")
    .doc(getuser.user!.uid)
    .collection("MyFocus");

// ignore: use_key_in_widget_constructors
class AddTimer extends StatefulWidget {
  @override
  State<AddTimer> createState() => _AddTimerState();
}

class _AddTimerState extends State<AddTimer> {
  String priority = "High";
  String taskTitle = "";
  String timerDuration = "";
  final formKey3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
  }

  @override
  void dispose() {
    super.dispose();
    priority;
    timerDuration;
    taskTitle;
    formKey3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close,
                        color: Colors.deepPurpleAccent, size: 35.0),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Task Title",
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.deepPurpleAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Form(
                        key: formKey3,
                        child: TextFormField(
                          autocorrect: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter TaskTitle";
                            } else {
                              return null;
                            }
                          },
                          textCapitalization: TextCapitalization.words,
                          style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              taskTitle = value;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              taskTitle = value;
                              // ignore: avoid_print
                              print(taskTitle);
                            });
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Color(Colors.deepPurpleAccent.value),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding: const EdgeInsets.only(top: 14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: "Enter Task Name",
                            hintStyle: GoogleFonts.sourceSansPro(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color:
                                  Theme.of(context).textTheme.headline2!.color,
                            ),
                            prefixIcon:
                                const Icon(Icons.timer, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5,
                        style: BorderStyle.solid,
                        color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.9),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set Timer",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.deepPurpleAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hms,
                          alignment: Alignment.center,
                          backgroundColor: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                          onTimerDurationChanged: (value) {
                            setState(() {
                              timerDuration = value.toString();
                              // ignore: avoid_print
                              print(timerDuration);
                            });
                          })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Priority - ",
                        style: GoogleFonts.overpass(
                            fontSize: 20,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Row(
                            children: [
                              Radio(
                                  activeColor: Colors.greenAccent,
                                  value: "Low",
                                  groupValue: priority,
                                  onChanged: (value) {
                                    setState(() {
                                      priority = value.toString();
                                      // ignore: avoid_print
                                      print(priority);
                                    });
                                  }),
                              Text(
                                "Low",
                                style: GoogleFonts.sourceSansPro(
                                  color: Colors.greenAccent,
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Radio(
                                  activeColor: Colors.yellowAccent,
                                  value: "Medium",
                                  groupValue: priority,
                                  onChanged: (value) {
                                    setState(() {
                                      priority = value.toString();
                                      // ignore: avoid_print
                                      print(priority);
                                    });
                                  }),
                              Text(
                                "Medium",
                                style: GoogleFonts.sourceSansPro(
                                  color: Colors.yellowAccent,
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Radio(
                                  activeColor: Colors.redAccent,
                                  value: "High",
                                  groupValue: priority,
                                  onChanged: (value) {
                                    setState(() {
                                      priority = value.toString();
                                      // ignore: avoid_print
                                      print(priority);
                                    });
                                  }),
                              Text(
                                "High",
                                style: GoogleFonts.sourceSansPro(
                                  color: Colors.redAccent,
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: TextButton(
                    child: Text(
                      "SAVE",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey3.currentState!.validate()) {
                        await isInternet(context).whenComplete(
                          () => ref
                              .add({
                                "color": Functions.prioritycolor(priority),
                                "titleName": taskTitle,
                                "duration": timerDuration,
                                "priority": priority,
                                "date": FieldValue.serverTimestamp(),
                              })
                              .whenComplete(
                                () => Navigator.pop(context),
                              )
                              // ignore: avoid_print
                              .whenComplete(() => print("Added SucessFuly")),
                        );
                      } else {
                        // ignore: avoid_print
                        print("ERROR EMPTY TITLE NAME");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
