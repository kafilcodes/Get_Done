import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8360736405719555/8752361791";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8360736405719555/2166363026";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8360736405719555/6388872589";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8360736405719555/7318810875";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
