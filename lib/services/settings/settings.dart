import 'package:get_done/ad/ads.dart';
import 'package:get_done/services/settings/widgets/SettiingsWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/services/others/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SettingsWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.sourceSansPro(
              color: Theme.of(context).iconTheme.color!.withOpacity(0.9),
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: 1),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).iconTheme.color,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black26,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          getuser.user!.email.toString(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSansPro(
                            color: Theme.of(context).textTheme.headline2!.color,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        getuser.user!.photoURL.toString(),
                        scale: 100,
                      ),
                    ),
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SettingsWidget(),
                const SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: MyBannerAd(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
