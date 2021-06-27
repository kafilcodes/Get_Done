import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: use_key_in_widget_constructors
class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SpinKitPulse(
              duration: const Duration(minutes: 5),
              color: Colors.redAccent,
              size: 70,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Oops ! No Internet ",
              textAlign: TextAlign.center,
              style: GoogleFonts.sourceSansPro(
                color: Colors.redAccent,
                letterSpacing: 1,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
