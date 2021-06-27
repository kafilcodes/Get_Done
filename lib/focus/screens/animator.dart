import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_done/focus/others/utils.dart';
import 'package:get_done/services/notifications/dnd.dart';
import 'dart:math' as math;
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:wakelock/wakelock.dart';

late AnimationController controller;
Duration parsedDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

// ignore: must_be_immutable
class Animator extends StatefulWidget {
  DocumentSnapshot animDur;
  // ignore: use_key_in_widget_constructors
  Animator({required this.animDur});
  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator>
    with SingleTickerProviderStateMixin {
  bool screenLock = false;
  bool notification = false;

  @override
  void initState() {
    super.initState();
    GoogleFonts.config;
    // ignore: avoid_print
    print("Focus Page INIT");
    controller = AnimationController(
      vsync: this,
      duration: parsedDuration(widget.animDur["duration"]),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
    Wakelock();

    // ignore: avoid_print
    print("Animator Dispose");
  }

  _buildCard({
    required Config config,
    Color backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = double.infinity,
  }) {
    return WaveWidget(
      heightPercentange: double.infinity,
      config: config,
      backgroundColor: Colors.transparent,
      backgroundImage: backgroundImage,
      size: Size(
        double.infinity,
        controller.value * MediaQuery.of(context).size.height,
      ),
      waveAmplitude: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.red,
            size: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: IconButton(
          icon: Icon(
            Icons.do_not_disturb_off,
            color:
                notification ? Colors.redAccent.withOpacity(0.7) : Colors.grey,
            size: 25,
          ),
          onPressed: () async {
            setState(() {
              notification = !notification;
            });
            DND.setDnd();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                screenLock = !screenLock;
              });
              Wakelock.toggle(enable: screenLock);
              // ignore: avoid_print
              print("display on - $screenLock");
            },
            icon: Icon(
              Icons.brightness_7_sharp,
              color:
                  screenLock ? Colors.redAccent.withOpacity(0.7) : Colors.grey,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildCard(
                        height: double.maxFinite,
                        backgroundColor: Colors.transparent,
                        config: CustomConfig(
                          gradients: [
                            [
                              Colors.grey.withOpacity(0.5),
                              const Color(0xEEF44336)
                            ],
                            [Colors.pinkAccent, const Color(0x77E57373)],
                            [Colors.deepPurple, const Color(0x66FF9800)],
                            [Colors.deepPurpleAccent, const Color(0x55FFEB3B)]
                          ],
                          durations: [35000, 19440, 10800, 6000],
                          heightPercentages: [0.20, 0.23, 0.25, 0.30],
                          gradientBegin: Alignment.bottomLeft,
                          gradientEnd: Alignment.topRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: CustomPaint(
                                          painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.transparent,
                                            color: Colors.red,
                                            // themeData.indicatorColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            widget.animDur["titleName"],
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 20.0,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .color),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              TimerS.timerString,
                                              style: GoogleFonts.sourceSansPro(
                                                fontSize: 100.0,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                              animation: controller,
                              builder: (context, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Colors.redAccent,
                                    onPressed: () {
                                      if (controller.isAnimating) {
                                        setState(() {
                                          controller.stop();
                                        });
                                      } else {
                                        setState(
                                          () {
                                            controller.reverse(
                                                from: controller.value == 0.0
                                                    ? 1.0
                                                    : controller.value);
                                          },
                                        );
                                      }
                                    },
                                    icon: Icon(
                                        controller.isAnimating
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white),
                                    label: Text(
                                      controller.isAnimating ? "Pause" : "Play",
                                      style: GoogleFonts.sourceSansPro(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
