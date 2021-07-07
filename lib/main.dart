import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_done/handler/landingPage.dart';
import 'package:get_done/services/notifications/firebase_notification_handler.dart';
import 'package:get_done/theme/app_theme_provider.dart';
import 'package:get_done/theme/shared_utility.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  MobileAds.instance.initialize();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    // override the previous value with the new object
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: MyApp()));
}

// ignore: use_key_in_widget_constructors
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _appThemeState = watch(appThemeStateProvider);
    SystemChrome.setEnabledSystemUIOverlays([]);

    return OverlaySupport.global(
      child: MaterialApp(
        theme: context
            .read(appThemeProvider)
            .getAppThemedata(context, _appThemeState),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          duration: 1,
          animationDuration: Duration(seconds: 1),
          splash: Image.asset(
            "assets/images/ic_launcher.png",
            width: 200,
            height: 200,
          ),
          nextScreen: LandingPage(),
          splashIconSize: 180,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // ignore: avoid_print

  dynamic data = message.data["data"];
  FirebaseNotification.showNotification(data["title"], data["body"]);
}
