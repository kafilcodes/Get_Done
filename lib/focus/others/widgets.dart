import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_done/focus/screens/addTimer.dart';
import 'package:get_done/focus/screens/animator.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusWidget extends StatefulWidget {
  final AsyncSnapshot snap;

  FocusWidget({required this.snap});

  @override
  _FocusWidgetState createState() => _FocusWidgetState();
}

class _FocusWidgetState extends State<FocusWidget> {
  bool isSelected = false;
  Color mycolor = Colors.white;

  @override
  void initState() {
    super.initState();
    widget.snap;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleSelection() {
    setState(() {
      if (isSelected) {
        mycolor = Colors.white;
        isSelected = false;
      } else {
        mycolor = Colors.grey.shade300;
        isSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        controller: ScrollController(),
        itemCount: widget.snap.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot documentSnapshot = widget.snap.data!.docs[index];
          deleteFocus(item) {
            DocumentReference documentReference = ref.doc(item);
            documentReference.delete().whenComplete(() {});
          }

          return Card(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              selected: isSelected,
              onLongPress: toggleSelection,
              title: Text(
                documentSnapshot["titleName"],
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                  fontSize: 23,
                  color: Color(documentSnapshot["color"]).withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                documentSnapshot["duration"],
                textAlign: TextAlign.center,
                style: GoogleFonts.sourceSansPro(
                  fontSize: 17,
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              leading: isSelected
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isSelected = false;
                        });
                      },
                      icon: Icon(
                        Icons.done,
                        size: 30,
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                  : Text(
                      documentSnapshot["priority"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              Color(documentSnapshot["color"]).withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
              trailing: isSelected
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 25),
                      onPressed: () {
                        HapticFeedback.lightImpact();

                        deleteFocus(documentSnapshot.id);
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.play_circle_filled_sharp,
                        color:
                            Color(documentSnapshot["color"]).withOpacity(0.8),
                        size: 30,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Animator(animDur: documentSnapshot),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
