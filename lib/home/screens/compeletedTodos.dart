// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/home/others/functions.dart';
import 'package:get_done/home/others/utils.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

// ignore: use_key_in_widget_constructors
class CompletedTodosPage extends StatefulWidget {
  @override
  _CompletedTodosPageState createState() => _CompletedTodosPageState();
}

class _CompletedTodosPageState extends State<CompletedTodosPage> {
  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: HomeReference.homeref
            .where('isCompleted', isEqualTo: true)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Card(
                          elevation: 0,
                          shadowColor: Colors.grey,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                                checkColor: Colors.green,
                                onChanged: (bool? value) {
                                  HapticFeedback.lightImpact();
                                  documentSnapshot.reference.update({
                                    "isCompleted": false,
                                    // "subtask.tasks.completed": false
                                  });
                                },
                                value: documentSnapshot["isCompleted"]),
                            title: Text(
                              documentSnapshot["todoTitle"],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sourceSansPro(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.redAccent,
                                size: 27,
                              ),
                              onPressed: () {
                                Functions.deleteTodos(documentSnapshot.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "No Data Available Right Now ",
              textAlign: TextAlign.center,
              style: GoogleFonts.sourceSansPro(
                color: Colors.redAccent.shade200,
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 5,
              ),
            );
          }
        },
      ),
    );
  }
}
