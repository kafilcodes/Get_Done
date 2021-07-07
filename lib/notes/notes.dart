import 'package:get_done/notes/others/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/notes/screens/add_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_done/notes/others/utils.dart';
import 'package:get_done/services/others/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

deleteNotes(item) {
  Reference.ref.doc(item).delete().whenComplete(() {
    // ignore: avoid_print
    print("NOTES - $item Deleted");
  });
}

// ignore: use_key_in_widget_constructors
class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController tcontroller2;
  bool searching2 = false;
  String searchedText2 = "";

  CollectionReference<Map<String, dynamic>> noteref = FirebaseFirestore.instance
      .collection("users")
      .doc(getuser.user!.uid)
      .collection("MyNotes");

  @override
  void initState() {
    super.initState();
    noteref;
    tcontroller2 = TextEditingController();
    GoogleFonts.config;
    const CircularProgressIndicator();
    // ignore: avoid_print
  }

  @override
  void dispose() {
    noteref;
    searchedText2;
    tcontroller2.dispose();
    super.dispose();
    // ignore: avoid_print
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: const Center(
            child: Icon(Icons.add, color: Colors.yellow, size: 30)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder(
        stream: searching2
            ? noteref.where("title", isEqualTo: searchedText2).snapshots()
            : noteref.orderBy('date', descending: true).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<dynamic, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CupertinoSearchTextField(
                      itemColor: Colors.yellowAccent.withOpacity(0.9),
                      placeholder: "Search  Notes",
                      placeholderStyle: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.headline2!.color,
                      ),
                      suffixMode: OverlayVisibilityMode.always,
                      suffixIcon: Icon(
                        Icons.cancel,
                        size: 22,
                        color: searching2
                            ? Colors.yellowAccent.withOpacity(0.7)
                            : Colors.transparent,
                      ),
                      onSuffixTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          tcontroller2.clear();
                          searchedText2 = "";
                          searching2 = false;
                        });
                      },
                      controller: tcontroller2,
                      backgroundColor: Colors.black26,
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline2!.color,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searching2 = true;
                        });
                        searchedText2 = value;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Divider(
                      height: 1,
                      thickness: 2,
                      color: Colors.white60,
                      indent: 90,
                      endIndent: 90,
                    ),
                  ),
                  NotesWidgets(snaps: snapshot),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "No Data Available Right Now ",
              overflow: TextOverflow.ellipsis,
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
                color: Colors.yellowAccent,
                strokeWidth: 5,
              ),
            );
          }
        },
      ),
    );
  }
}
