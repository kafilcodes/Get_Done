import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_done/home/others/functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/services/audio/audio.dart';

// ignore: must_be_immutable
class TodoWidget extends StatefulWidget {
  DocumentSnapshot docsnap;

  // ignore: use_key_in_widget_constructors
  TodoWidget({required this.docsnap});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  bool isExpand = false;
  bool update = false;

  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
  }

  @override
  void dispose() {
/*    player.dispose();*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Functions.deleteTodos(widget.docsnap.id);
      },
      key: Key(widget.docsnap["todoTitle"]),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Card(
          elevation: 3,
          shadowColor: Color(widget.docsnap["color"]).withOpacity(0.9),
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ExpansionTile(
            textColor: Colors.redAccent,
            iconColor: Colors.redAccent,
            leading: Checkbox(
                onChanged: (bool? value) {
                  HapticFeedback.heavyImpact()
                      .whenComplete(
                        () => Audio.playsound(),
                      )
                      .whenComplete(() => widget.docsnap.reference
                          .update({"isCompleted": true}));
                },
                value: widget.docsnap["isCompleted"]),
            title: Text(
              widget.docsnap["todoTitle"],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Description -",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.docsnap["desc"],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
