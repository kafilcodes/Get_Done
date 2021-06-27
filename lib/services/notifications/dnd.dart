// Import package
import 'package:get_done/services/notifications/dnd_services.dart';

class DND {
  static void setDnd() async {
    if (await FlutterDnd.isNotificationPolicyAccessGranted) {
      await FlutterDnd.setInterruptionFilter(FlutterDnd
          .INTERRUPTION_FILTER_ALARMS); // Turn on DND - All notifications are suppressed.
    } else {
      FlutterDnd.gotoPolicySettings();
    }
  }
}
