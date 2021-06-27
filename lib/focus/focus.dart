import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/ad/ads.dart';
import 'package:get_done/focus/screens/addTimer.dart';
import 'package:get_done/focus/screens/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_done/services/others/utils.dart';

String titleName = "";
int time = 0;
int breakTime = 0;

class MyFocusPage extends StatefulWidget {
  @override
  _MyFocusPageState createState() => _MyFocusPageState();
}

class _MyFocusPageState extends State<MyFocusPage> {
  bool isSelected = false;
  Color mycolor = Colors.white;

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
  void initState() {
    GoogleFonts.config;
    super.initState();
    print("Focus Page INIT");
  }

  @override
  void dispose() {
    super.dispose();
    print("Focus Page Dispose");
  }

  CollectionReference ref = FirebaseFirestore.instance
      .collection("users")
      .doc(getuser.user!.uid)
      .collection("MyFocus");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: const Icon(Icons.add, color: Colors.deepPurpleAccent, size: 35),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTimer()));
        },
      ),
      body: StreamBuilder(
        stream: ref
            .where('date', isGreaterThanOrEqualTo: date.start)
            .where('date', isLessThanOrEqualTo: date.end)
            .limit(5)
            .orderBy('date')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   margin:
                    //       EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    //   child: Text(
                    //     "Tasks",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       color: Colors.deepPurpleAccent,
                    //       fontSize: 40,
                    //       fontFamily: "WorkSans",
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      width: MediaQuery.of(context).size.width / 0.9,
                      height: 77,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: const Text(
                                  "2.5 Hrs",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                child: const Text(
                                  "Estimated Time",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              "|",
                              style: const TextStyle(
                                fontSize: 35,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                child: const Text(
                                  "Total Tasks",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      width: double.infinity,
                      height: 420,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data!.docs[index];
                          deleteFocus(item) {
                            DocumentReference documentReference = ref.doc(item);
                            documentReference.delete().whenComplete(() {
                              print(" FOCUS- $item Deleted");
                            });
                          }

                          return Card(
                            child: ListTile(
                              selected: isSelected,
                              onLongPress: toggleSelection,
                              title: Text(
                                documentSnapshot["titleName"],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 25,
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot["duration"],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              leading: Text(
                                documentSnapshot["priority"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                              trailing: isSelected
                                  ? IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red, size: 25),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        // setState(() {
                                        deleteFocus(documentSnapshot.id);
                                        // isSelected = false;
                                        // });
                                        setState(() {
                                          isSelected = false;
                                        });
                                      })
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.play_circle_filled_sharp,
                                        color: Colors.deepPurpleAccent,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Animator(
                                                animDur: documentSnapshot),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: MyBannerAd(),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("No Data Available Right Now ");
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
                strokeWidth: 5,
              ),
            );
          }
        },
      ),
    );
  }
}
