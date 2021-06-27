import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/theme/shared_utility.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* AppTheme */

final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class AppTheme {
  //Modify to add more colors here
  static final ThemeData _lightThemeData = ThemeData(
    focusColor: Colors.redAccent.withOpacity(0.7),
    textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
      headline1: const TextStyle(color: Colors.redAccent),
      headline2: const TextStyle(color: Colors.black),
      headline3: const TextStyle(color: Colors.black),
      headline4: const TextStyle(color: Colors.black),
      headline5: const TextStyle(color: Colors.black),
      headline6: const TextStyle(
        color: Colors.black,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Colors.red, opacity: 0.8),
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.light,
    primaryColorLight: Colors.redAccent,
    primaryColorDark: Colors.white54,
    primaryColor: Colors.blueGrey[600],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        primary: Colors.red,
      ),
    ),
  );

  static final ThemeData _darkThemeData = ThemeData(
    focusColor: Colors.deepPurpleAccent.withOpacity(1),
    textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
      headline1: TextStyle(color: Colors.deepPurpleAccent.shade100),
      headline2: const TextStyle(color: Colors.white),
      headline3: const TextStyle(color: Colors.white),
      headline4: const TextStyle(color: Colors.white),
      headline5: const TextStyle(color: Colors.white),
      headline6: const TextStyle(
        color: Colors.white,
      ),
    ),
    primaryColor: Colors.grey,
    colorScheme: const ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade100, opacity: 1),
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.dark,
    primaryColorLight: Colors.deepPurpleAccent,
    primaryColorDark: Colors.grey[900],
    scaffoldBackgroundColor: Colors.black45,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        primary: Colors.blue,
      ),
    ),
  );

  ThemeData getAppThemedata(BuildContext context, bool isDarkModeEnabled) {
    return isDarkModeEnabled ? _darkThemeData : _lightThemeData;
  }
}

/* AppTheme Notifier */

final appThemeStateProvider =
    StateNotifierProvider<AppThemeNotifier, bool>((ref) {
  final _isDarkModeEnabled =
      ref.read(sharedUtilityProvider).isDarkModeEnabled();
  return AppThemeNotifier(_isDarkModeEnabled);
});

class AppThemeNotifier extends StateNotifier<bool> {
  AppThemeNotifier(this.defaultDarkModeValue) : super(defaultDarkModeValue);

  final bool defaultDarkModeValue;

  toggleAppTheme(BuildContext context) {
    final _isDarkModeEnabled =
        context.read(sharedUtilityProvider).isDarkModeEnabled();
    final _toggleValue = !_isDarkModeEnabled;

    context
        .read(
          sharedUtilityProvider,
        )
        .setDarkModeEnabled(_toggleValue)
        .whenComplete(
          () => {
            state = _toggleValue,
          },
        );
  }
}
