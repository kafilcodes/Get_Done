import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_done/home/others/functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/services/others/internet.dart';

class AddTodos extends StatefulWidget {
  @override
  _AddTodosState createState() => _AddTodosState();
}

class _AddTodosState extends State<AddTodos> {
  late TextEditingController scontroller;
  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
    // scontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    scontroller.dispose();
    Functions.todoTitle;
    // Functions.subtaskt;
    Functions.todoDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "ADD TODOS",
          style: GoogleFonts.ubuntuCondensed(
              color: Theme.of(context).iconTheme.color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 35),
            onPressed: () async {
              await isInternet(context).whenComplete(
                () => Functions.createTodos(),
              );

              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.library_add_check,
              size: 35,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 15,
              ),
              //textField title
              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.all(10),
                color: Colors.transparent,
                child: TextField(
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onChanged: (value) {
                    Functions.todoTitle = value;
                  },
                  onSubmitted: (value) {
                    Functions.todoTitle = value;
                  },
                  maxLines: 1,
                  cursorColor: Theme.of(context).iconTheme.color,
                  textInputAction: TextInputAction.done,
                  textDirection: TextDirection.ltr,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Title',
                    hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  maxLength: 300,
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onChanged: (value) {
                    Functions.todoDescription = value;
                  },
                  onSubmitted: (value) {
                    Functions.todoDescription = value;
                  },
                  maxLines: 3,
                  cursorColor: Colors.redAccent,
                  textInputAction: TextInputAction.done,
                  textDirection: TextDirection.ltr,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.red,
                    hintText: 'Short Description',
                    hintStyle: GoogleFonts.sourceSansPro(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Priority - ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.overpass(
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.7),
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Row(
                        children: [
                          Radio(
                              activeColor: Colors.greenAccent,
                              value: "Low",
                              groupValue: Functions.priority,
                              onChanged: (value) {
                                setState(() {
                                  Functions.priority = value.toString();
                                  print(Functions.priority);
                                });
                              }),
                          Text(
                            "Low",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Radio(
                              activeColor: Colors.yellowAccent,
                              value: "Medium",
                              groupValue: Functions.priority,
                              onChanged: (value) {
                                setState(() {
                                  Functions.priority = value.toString();
                                  print(Functions.priority);
                                });
                              }),
                          Text(
                            "Medium",
                            style: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.yellowAccent),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Radio(
                              activeColor: Colors.redAccent,
                              value: "High",
                              groupValue: Functions.priority,
                              onChanged: (value) {
                                setState(() {
                                  Functions.priority = value.toString();
                                  print(Functions.priority);
                                });
                              }),
                          Text(
                            "High",
                            style: GoogleFonts.sourceSansPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
