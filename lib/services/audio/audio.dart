import 'package:just_audio/just_audio.dart' show AudioPlayer;

class Audio {
  static late AudioPlayer player = AudioPlayer();
  static late AudioPlayer player2 = AudioPlayer();

  static void playsound() async {
    await player.setAsset("assets/sounds/3.wav");

    player.load();
    player.play();
    player.setSpeed(2);
  }

  static void playsound2() async {
    await player2.setAsset("assets/sounds/2.wav");
    player2.load();
    player2.play();
    player2.setSpeed(2);
  }
}
