import 'package:get_done/ad/ads.dart';
import 'package:get_done/services/notifications/firebase_notification_handler.dart';
import 'package:get_done/theme/app_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/services/user/auth.dart';
import 'package:get_done/services/user/changePassword.dart';
import 'package:get_done/services/others/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String fullName = "";
TextEditingController controller = TextEditingController();

// ignore: use_key_in_widget_constructors
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ignore: non_constant_identifier_names
  bool DarkMode = false;
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();

    // ignore: avoid_print
    print("Settings - INIT");
  }

  @override
  void dispose() {
    super.dispose();
    // ignore: avoid_print
    print("Settings - Dispose");
  }

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) {
    final _appThemeStateProvider = context.read(appThemeStateProvider.notifier);
    List<String> settingString = [
      "Change Password",
      "Dark Mode",
      "Push Notification",
      "Sign Out",
    ];

    List<Widget> settingTrailing = [
      IconButton(
        icon: Icon(
          Icons.chevron_right,
          color: Theme.of(context).iconTheme.color,
          size: 40,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()));
        },
      ),
      Switch.adaptive(
          activeColor: Theme.of(context).iconTheme.color,

// ignore: invalid_use_of_protected_member
          value: _appThemeStateProvider.state,
          onChanged: (value) {
            _appThemeStateProvider.toggleAppTheme(context);
          }),
      Switch.adaptive(
        activeColor: Theme.of(context).iconTheme.color,
// ignore: invalid_use_of_protected_member
        value: isSwitched,
        onChanged: (value) async {
          isSwitched
              ? FirebaseNotification().dpnsubscribe()
              : FirebaseNotification().dpnunsubscribe();

          setState(() {
            isSwitched = !isSwitched;
          });
        },
      ),
      IconButton(
        icon: Icon(
          Icons.logout,
          color: Theme.of(context).iconTheme.color,
          size: 32,
        ),
        onPressed: () async {
          await AuthClass().signOutUser(context);
        },
      ),
    ];

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
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 310,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListView.builder(
                      itemCount: settingString.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              settingString[index],
                              style: GoogleFonts.sourceSansPro(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .color,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            trailing: settingTrailing[index],
                          ),
                        );
                      }),
                ),
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
