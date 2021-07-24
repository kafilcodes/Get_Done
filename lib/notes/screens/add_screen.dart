import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_done/services/audio/audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';
import 'package:get_done/notes/others/utils.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:text_style_editor/text_style_editor.dart';

// ignore: use_key_in_widget_constructors
class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String titleText = "";
  String descriptionText = "";
  String tag = "";
  Color updatedColor2 = Color(Colors.redAccent.value);
  bool recording = false;

  @override
  void initState() {
    super.initState();
    Audio.myRecorder.openAudioSession().then((value) {
      setState(() {
        recording = true;
      });
    });
    myStyle.textStyle;
    myStyle.textAlign;
    myColor.selectedColor;
    Reference.ref;
  }

  @override
  void dispose() {
    super.dispose();
    Audio.myRecorder.closeAudioSession();
    recording = false;

    titleText;
    descriptionText;
    updatedColor2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: updatedColor2.withOpacity(0.9),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "ADD NOTES",
          style: GoogleFonts.sourceSansPro(
            color: Colors.yellow,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  recording = !recording;
                });
                recording ? Audio.record() : Audio.stopRecorder();
              },
              icon: Icon(
                Icons.mic,
                size: 30,
                color: recording ? Colors.redAccent : Colors.grey,
              )),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(Icons.done, color: Colors.white, size: 30),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await isInternet(context).whenComplete(
                () => Reference.ref.add({
                  "title": titleText,
                  "description": descriptionText,
                  "date": FieldValue.serverTimestamp(),
                  "color": updatedColor2.value,
                  "textstyle": {
                    "bcolor": myStyle.textStyle.backgroundColor!.value,
                    "fontFamily": myStyle.textStyle.fontFamily,
                    "tcolor": myStyle.textStyle.color!.value,
                    "fontSize": myStyle.textStyle.fontSize,
                  }
                }).whenComplete(
                  () => Navigator.pop(context),
                ),
              );
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              textInputAction: TextInputAction.next,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Title',
                hintStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70),
              ),
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70),
              onChanged: (value) {
                titleText = value;
              },
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.characters,
                enableSuggestions: true,
                maxLines: 150,
                textDirection: TextDirection.ltr,
                autofocus: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white54,
                  ),
                ),
                style: myStyle.textStyle,
                textAlign: myStyle.textAlign,
                onChanged: (value) {
                  descriptionText = value;
                },
              ),
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 60,
              width: 100,
              child: HuePicker(
                initialColor:
                    HSVColor.fromColor(Colors.redAccent.withOpacity(0.9)),
                onChanged: (HSVColor color) {
                  setState(() {
                    updatedColor2 = myColor.selectedColor = color.toColor();
                    // ignore: avoid_print
                  });
                  // ignore: avoid_print

                  // do something with color
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: SingleChildScrollView(
                  child: TextStyleEditor(
                    // ignore: non_constant_identifier_names
                    onToolbarActionChanged: (Edit) {
                      setState(() {
                        myStyle.edited = Edit;
                      });
                    },
                    fonts: listText.fonts,
                    paletteColors: listText.paletteColors,
                    textStyle: myStyle.textStyle,
                    textAlign: myStyle.textAlign,
                    initialTool: EditorToolbarAction.fontFamilyTool,
                    onTextAlignEdited: (align) {
                      setState(() {
                        myStyle.textAlign = align;
                      });
                    },
                    onTextStyleEdited: (style) {
                      setState(() {
                        myStyle.textStyle = myStyle.textStyle.merge(style);
                      });
                    },
                    onCpasLockTaggle: (caps) {
                      // ignore: avoid_print
                      print(caps);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
