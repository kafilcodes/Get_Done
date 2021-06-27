import 'package:connectivity/connectivity.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';

import 'package:get_done/services/others/etc.dart';
import 'package:overlay_support/overlay_support.dart';

Future<bool> isInternet(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Mobile data detected & internet connection confirmed.
      return true;
    } else {
      // Mobile data detected but no internet connection found.
      return Connectionbar.showTopSnackBar(
          context, "Please Check Your Internet Connection", Colors.red);
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a WIFI network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Wifi detected & internet connection confirmed.
      return true;
    } else {
      // Wifi detected but no internet connection found.
      return Connectionbar.showTopSnackBar(
          context, "Please Check Your Internet Connection", Colors.red);
    }
  } else {
    // Neither mobile data or WIFI detected, not internet connection found.
    return Connectionbar.showTopSnackBar(
        context, "Please Check Your Internet Connection", Colors.red);
  }
}

class Connectionbar {
  static showTopSnackBar(
    BuildContext context,
    String message,
    Color color,
  ) =>
      showSimpleNotification(
        const Text('OOPS NO INTERNET !😢'),
        duration: const Duration(seconds: 1),
        subtitle: Text(message),
        background: color,
      );
}
