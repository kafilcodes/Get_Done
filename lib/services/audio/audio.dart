import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

class Audio {
  static FlutterSoundRecorder myRecorder = FlutterSoundRecorder();

  static Future<void> record() async {
    await myRecorder.startRecorder(
      toFile: "assets/record/",
      codec: Codec.aacADTS,
    );
  }

  static Future<void> stopRecorder() async {
    await myRecorder.stopRecorder();
  }
}
