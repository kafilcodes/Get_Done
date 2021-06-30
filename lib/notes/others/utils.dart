import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_done/services/others/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_style_editor/text_style_editor.dart';

// ignore: camel_case_types
class myColor {
  static Color selectedColor = Color(Colors.yellowAccent.value);
}

class Reference {
  static CollectionReference ref = FirebaseFirestore.instance
      .collection("users")
      .doc(getuser.user!.uid)
      .collection("MyNotes");
}

class listText {
  static List<String> fonts = [
    GoogleFonts.openSansCondensed().fontFamily.toString(),
    GoogleFonts.cedarvilleCursive().fontFamily.toString(),
    GoogleFonts.allura().fontFamily.toString(),
    GoogleFonts.castoro().fontFamily.toString(),
    GoogleFonts.sofia().fontFamily.toString(),
    GoogleFonts.grandHotel().fontFamily.toString(),
    GoogleFonts.greatVibes().fontFamily.toString(),
    GoogleFonts.lobster().fontFamily.toString(),
    GoogleFonts.fugazOne().fontFamily.toString(),
    GoogleFonts.firaSansCondensed().fontFamily.toString(),
    GoogleFonts.oswald().fontFamily.toString(),
    GoogleFonts.pacifico().fontFamily.toString(),
    GoogleFonts.quicksand().fontFamily.toString(),
    GoogleFonts.robotoCondensed().fontFamily.toString(),
    GoogleFonts.saira().fontFamily.toString(),
    GoogleFonts.tradeWinds().fontFamily.toString(),
  ];
  static List<Color> paletteColors = [
    Colors.transparent,
    Colors.black,
    Colors.white,
    Color(int.parse('0xffEA2027')),
    Color(int.parse('0xff006266')),
    Color(int.parse('0xff1B1464')),
    Color(int.parse('0xff5758BB')),
    Color(int.parse('0xff6F1E51')),
    Color(int.parse('0xffB53471')),
    Color(int.parse('0xffEE5A24')),
    Color(int.parse('0xff009432')),
    Color(int.parse('0xff0652DD')),
    Color(int.parse('0xff9980FA')),
    Color(int.parse('0xff833471')),
    Color(int.parse('0xff112CBC4')),
    Color(int.parse('0xffFDA7DF')),
    Color(int.parse('0xffED4C67')),
    Color(int.parse('0xffF79F1F')),
    Color(int.parse('0xffA3CB38')),
    Color(int.parse('0xff1289A7')),
    Color(int.parse('0xffD980FA'))
  ];
}

class myStyle {
  static TextStyle textStyle = GoogleFonts.sourceSansPro(
    fontStyle: FontStyle.normal,
    backgroundColor: Colors.transparent,
    fontSize: 22,
    color: Colors.white,
  );
  static TextAlign textAlign = TextAlign.left;
  static EditorToolbarAction edited = EditorToolbarAction.editor;
}
