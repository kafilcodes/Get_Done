import 'package:just_audio/just_audio.dart' show AudioPlayer;

class Audio {
  static late AudioPlayer player = AudioPlayer();
  static late AudioPlayer player2 = AudioPlayer();
  static late AudioPlayer player3 = AudioPlayer();

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

  static void playsound3() async {
    await player3.setAsset("assets/sounds/notification1.wav");
    player3.load();
    player3.play();
    player3.setSpeed(1);
  }
}
