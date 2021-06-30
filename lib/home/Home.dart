// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_done/ad/ads.dart';

// import 'package:get_done/ad/ads.dart';
import 'package:get_done/home/screens/add_Todos.dart';
import 'package:get_done/home/screens/compeletedTodos.dart';
import 'package:get_done/home/others/utils.dart';
import 'package:get_done/home/others/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:get_done/services/others/utils.dart';
import 'package:google_fonts/google_fonts.dart';

import '../focus/focus.dart';
import '../notes/notes.dart';
import '../services/settings/settings.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController; // To control switching tabs
  late ScrollController _scrollViewController;

  // To control scrolling
  @override
  // ignore: must_call_super
  void initState() {
    GoogleFonts.config;
    getuser();
    _tabController = TabController(vsync: this, length: 3);
    _scrollViewController = ScrollController();
    NotesPage();
    ToDoSection();
    MyFocusPage();
    // ignore: avoid_print
    print("Home Page INIT");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
    // ignore: avoid_print
    print("Home Page Dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: Theme.of(context).iconTheme,
                  floating: true,
                  snap: false,
                  pinned: true,
                  centerTitle: true,
                  title: Text(
                    "Get  Done",
                    style: GoogleFonts.sourceSansPro(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 24),
                    maxLines: 1,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.segment,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  bottom: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                            colors: [
                              Colors.grey.withOpacity(0.5),
                              Colors.white60
                            ]),
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.redAccent),
                    tabs: <Widget>[
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: Colors.yellowAccent, width: 2),
                          ),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sticky_note_2_outlined,
                              color: Colors.yellowAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: Colors.redAccent, width: 2),
                          ),
                          child: const Align(
                            child: Icon(Icons.done_outline_sharp,
                                color: Colors.redAccent, size: 26),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Colors.deepPurpleAccent, width: 2)),
                          child: const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.alarm_on,
                              color: Colors.deepPurpleAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                NotesPage(),
                ToDoSection(),
                MyFocusPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//---------------------------------------TODO-PAGE------------------------------

// ignore: use_key_in_widget_constructors
class ToDoSection extends StatefulWidget {
  @override
  _ToDoSectionState createState() => _ToDoSectionState();
}

class _ToDoSectionState extends State<ToDoSection> {
  late bool isLoaded;
  late TextEditingController tcontroller;
  bool searching = false;
  String searchedText = "";

  @override
  void initState() {
    GoogleFonts.config;
    super.initState();

    tcontroller = TextEditingController();
    // const MyNativeAd();
    HomeReference.homeref;
  }

  @override
  void dispose() {
    searching;
    searchedText;
    tcontroller.clear();
    tcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onPressed: () {
            HapticFeedback.lightImpact().whenComplete(() => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTodos())));
          },
          child: Icon(Icons.add,
              color: Colors.redAccent.withOpacity(1), size: 35)),
      body: StreamBuilder(
        stream: searching
            ? HomeReference.homeref
                .where("todoTitle", isEqualTo: searchedText)
                .where('isCompleted', isEqualTo: false)
                .snapshots()
            : HomeReference.homeref
                .where('isCompleted', isEqualTo: false)
                .where('date', isGreaterThanOrEqualTo: date.start)
                .where('date', isLessThanOrEqualTo: date.end)
                .orderBy('date')
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 120,
                            child: CupertinoSearchTextField(
                              itemColor: Colors.redAccent,
                              placeholder: "Search   Todos",
                              placeholderStyle: GoogleFonts.sourceSansPro(
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .color,
                              ),
                              suffixMode: OverlayVisibilityMode.always,
                              suffixIcon: Icon(Icons.cancel,
                                  size: 22,
                                  color: searching
                                      ? Colors.red.withOpacity(0.7)
                                      : Colors.transparent),
                              onSuffixTap: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  tcontroller.clear();
                                  searchedText = "";
                                  searching = false;
                                });
                              },
                              controller: tcontroller,
                              backgroundColor: Colors.black26,
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .color,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searching = true;
                                });
                                searchedText = value;
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 45,
                            height: 80,
                            child: IconButton(
                              alignment: Alignment.center,
                              onPressed: () {
                                HapticFeedback.mediumImpact().whenComplete(
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompletedTodosPage(),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.done_all,
                                color: Colors.redAccent,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: SafeArea(
                        child: ListView.separated(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (
                            context,
                            index,
                          ) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            return TodoWidget(docsnap: documentSnapshot);
                          },
                          separatorBuilder: (context, index) {
                            // ignore: sized_box_for_whitespace
                            return const SizedBox(
                              width: double.infinity,
                              height: 15,
                              child: MyNativeAd(),
                            );
                          },
                          // ignore: file_names
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "No Data Available Right Now :( ",
                style: GoogleFonts.sourceSansPro(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 5,
              ),
            );
          }
        },
      ),
    );
  }
}
