import 'package:get_done/focus/screens/animator.dart';

class TimerS {
  static String get timerString {
    Duration _duration = controller.duration! * controller.value;
    return '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}
