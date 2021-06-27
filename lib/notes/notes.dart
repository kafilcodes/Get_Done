import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/notes/screens/add_screen.dart';
import 'package:get_done/notes/screens/edit_note_screen.dart';
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

  @override
  void initState() {
    super.initState();
    tcontroller2 = TextEditingController();
    GoogleFonts.config;
    const CircularProgressIndicator();
    // ignore: avoid_print
    print('notes page INIT');
  }

  @override
  void dispose() {
    searchedText2;
    tcontroller2.dispose();
    super.dispose();
    // ignore: avoid_print
    print('notes page DISPOSE');
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
            ? FirebaseFirestore.instance
                .collection("users")
                .doc(getuser.user!.uid)
                .collection("MyNotes")
                .where("title", isEqualTo: searchedText2)
                .snapshots()
            : FirebaseFirestore.instance
                .collection("users")
                .doc(getuser.user!.uid)
                .collection("MyNotes")
                .snapshots(),
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
                      placeholder: "Search  Notes",
                      placeholderStyle: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Theme.of(context).textTheme.headline2!.color,
                      ),
                      autocorrect: false,
                      suffixMode: OverlayVisibilityMode.always,
                      suffixIcon: Icon(
                        Icons.cancel,
                        size: 22,
                        color: searching2
                            ? Colors.red.withOpacity(0.7)
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: GridView.builder(
                        controller: ScrollController(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditScreen(
                                    docEdit: snapshot.data!.docs[index],
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              HapticFeedback.heavyImpact();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text(
                                    "Delete Note ? ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.sourceSansPro(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  content: Text(
                                    "this action can't be Undo !",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.sourceSansPro(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: Text(
                                        "DELETE",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.sourceSansPro(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        deleteNotes(
                                            snapshot.data!.docs[index].id);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.all(15),
                              height: 100,
                              width: 50,
                              decoration: BoxDecoration(
                                color:
                                    Color(snapshot.data!.docs[index]['color'])
                                        .withOpacity(0.9),
                                // myColor.selectedColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    // snapshot.data.docs[index]['title'],
                                    snapshot.data!.docs[index]['title'],
                                    maxLines: 2,
                                    style: GoogleFonts.sourceSansPro(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    snapshot.data!.docs[index]['description'],
                                    maxLines: 6,
                                    style: GoogleFonts.sourceSansPro(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
