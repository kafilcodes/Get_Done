import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_done/notes/screens/edit_note_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesWidgets extends StatelessWidget {
  final AsyncSnapshot snaps;

  NotesWidgets({required this.snaps});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: GridView.builder(
          controller: ScrollController(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: snaps.data!.docs.length,
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      docEdit: snaps.data!.docs[index],
                    ),
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
                      Color(snaps.data!.docs[index]['color']).withOpacity(0.9),
                  // myColor.selectedColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        snaps.data!.docs[index]['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.sourceSansPro(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Expanded(
                      child: Text(
                        snaps.data!.docs[index]['description'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
