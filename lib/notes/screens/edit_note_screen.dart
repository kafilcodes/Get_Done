import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsv_color_pickers/hsv_color_pickers.dart';
import 'package:get_done/notes/others/utils.dart';
import 'package:get_done/services/others/internet.dart';
import 'package:text_style_editor/text_style_editor.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  DocumentSnapshot docEdit;
  // ignore: use_key_in_widget_constructors
  EditScreen({required this.docEdit});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Color updatedColor = Color(Colors.yellow.value);
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  bool textclicked = false;
  bool colorpclicked = false;
  bool editing = false;

  @override
  void initState() {
    title = TextEditingController(text: widget.docEdit["title"]);
    description = TextEditingController(text: widget.docEdit["description"]);
    myStyle.textStyle = TextStyle(
      backgroundColor: Color(widget.docEdit["textstyle"]["bcolor"]),
      fontSize: widget.docEdit["textstyle"]["fontSize"],
      fontFamily: widget.docEdit["textstyle"]["fontFamily"],
      color: Color(widget.docEdit["textstyle"]["tcolor"]),
    );
    myColor.selectedColor = Color(widget.docEdit["color"]);
    updatedColor = Color(widget.docEdit["color"]);
    myStyle.edited;
    myStyle.textStyle;
    myStyle.textAlign;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    description.dispose();
    myStyle.textStyle;
    textclicked;
    editing;
    colorpclicked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor.selectedColor.withOpacity(0.9),
      appBar: AppBar(
        centerTitle: false,
        elevation: null,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            editing ? "EDIT NOTES" : "NOTES",
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(
                color: updatedColor.withOpacity(1),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                editing = !editing;
              });
            },
            icon: Icon(
              Icons.edit,
              size: 27,
              color: editing ? updatedColor.withOpacity(1) : Colors.white,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline,
                color: Colors.red.withOpacity(0.8), size: 28),
            onPressed: () {
              widget.docEdit.reference
                  .delete()
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon:
                Icon(Icons.done, color: Colors.white.withOpacity(1), size: 31),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await isInternet(context).whenComplete(
                () => widget.docEdit.reference.update({
                  "title": title.text,
                  "description": description.text,
                  "color": updatedColor.value,
                  "textstyle.fontSize": myStyle.textStyle.fontSize,
                  "textstyle.fontFamily": myStyle.textStyle.fontFamily,
                  "textstyle.tcolor": myStyle.textStyle.color!.value,
                  "textstyle.bcolor": myStyle.textStyle.backgroundColor!.value,
                }).whenComplete(
                  () => Navigator.pop(context),
                ),
              );
            },
          ),
          const SizedBox(
            width: 23,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(23.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              enabled: editing,
              maxLines: 1,
              textCapitalization: TextCapitalization.sentences,
              autofocus: false,
              enableSuggestions: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Title',
                hintStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70),
              ),
              style: GoogleFonts.sourceSansPro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70),
              controller: title,
              onChanged: (value) {
                title = value as TextEditingController;
              },
            ),
            Expanded(
              child: TextField(
                onTap: () {
                  editing = !editing;
                },
                enabled: editing,
                maxLines: 8,
                scrollPhysics: const ClampingScrollPhysics(),
                enableSuggestions: true,
                autofocus: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: myStyle.textStyle,
                textAlign: myStyle.textAlign,
                controller: description,
                onChanged: (value) {
                  description = value as TextEditingController;
                },
              ),
            ),
            // ignore: sized_box_for_whitespace
            colorpclicked
                ? Container(
                    height: 60,
                    width: 100,
                    child: HuePicker(
                      initialColor: HSVColor.fromColor(
                        myColor.selectedColor =
                            Color(widget.docEdit["color"]).withOpacity(0.9),
                      ),
                      onChanged: (HSVColor color) {
                        setState(() {
                          updatedColor =
                              myColor.selectedColor = color.toColor();
                        });
                        // ignore: avoid_print
                        print(myColor.selectedColor.value);

                        // do something with color
                      },
                    ))
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
            const SizedBox(
              height: 20,
            ),
            textclicked
                ? Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
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
                              myStyle.textStyle =
                                  myStyle.textStyle.merge(style);
                            });
                          },
                          onCpasLockTaggle: (caps) {},
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
            editing
                ? Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              colorpclicked = !colorpclicked;
                            });
                          },
                          icon: Icon(Icons.color_lens,
                              size: 30,
                              color: colorpclicked
                                  ? updatedColor.withOpacity(1)
                                  : Colors.white),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              textclicked = !textclicked;
                            });
                          },
                          icon: Icon(Icons.text_fields,
                              size: 30,
                              color: textclicked
                                  ? updatedColor.withOpacity(1)
                                  : Colors.white),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
