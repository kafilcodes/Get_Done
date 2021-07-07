import 'package:flutter/services.dart';
import 'package:get_done/ad/ads.dart';
import 'package:get_done/focus/others/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/focus/screens/addTimer.dart';
import 'package:get_done/focus/screens/animator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFocusPage extends StatefulWidget {
  @override
  _MyFocusPageState createState() => _MyFocusPageState();
}

class _MyFocusPageState extends State<MyFocusPage> {
  @override
  void initState() {
    GoogleFonts.config;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
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
        stream: ref.limit(5).orderBy('date', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var ds = snapshot.data!.docs;
            Duration sum = const Duration();
            for (int i = 0; i < ds.length; i++)
              sum += parsedDuration(ds[i]['duration']);
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      height: 80,
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
                                child: Expanded(
                                  child: Text(
                                    "${sum.inMinutes.toString()} Min.",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                child: Expanded(
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    FocusWidget(snap: snapshot),
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
            return const Text(
              "No Data Available Right Now ",
              overflow: TextOverflow.ellipsis,
            );
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
