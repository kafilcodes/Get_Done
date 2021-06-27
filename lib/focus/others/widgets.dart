import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class firstSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 10,
          ),
          child: Text(
            "FOCUS",
            textAlign: TextAlign.start,
            style: GoogleFonts.firaSansCondensed(
              fontStyle: FontStyle.italic,
              color: Colors.grey[100],
              fontWeight: FontWeight.w500,
              fontSize: 40,
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: IconButton(
            icon: Icon(
              Icons.drag_handle_outlined,
              color: Colors.grey[100],
              size: 40,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
