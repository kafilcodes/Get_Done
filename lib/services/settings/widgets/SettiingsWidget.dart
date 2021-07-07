import 'package:flutter/material.dart';
import 'package:get_done/services/user/changePassword.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_done/services/user/auth.dart';
import 'package:get_done/services/notifications/firebase_notification_handler.dart';
import 'package:get_done/theme/app_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    isSwitched;
  }

  @override
  Widget build(BuildContext context) {
    final _appThemeStateProvider = context.read(appThemeStateProvider.notifier);

    final List<String> settingString = [
      "Change Password",
      "Dark Mode",
      "Push Notification",
      "Sign Out",
    ];

    final List<Widget> settingTrailing = [
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

    return Container(
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
                    color: Theme.of(context).textTheme.headline2!.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                trailing: settingTrailing[index],
              ),
            );
          }),
    );
  }
}
