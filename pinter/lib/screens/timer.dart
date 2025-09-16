import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:ritual/color_schemes.g.dart';

// Hive Model
import 'package:ritual/model/ritual.dart';

// Services
import 'package:ritual/services/boxes.dart';
import 'package:ritual/services/misc.dart';
import 'package:ritual/services/shared_prefs.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  // Notification Tone Player
  final assetsAudioPlayer = AssetsAudioPlayer();

  int habitIndex = 0;

  // CountDownContoller Instance
  CountDownController countDownCtrlr = CountDownController();

  @override
  void initState() {
    // Hide status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    // Allow only portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get data from parent screen
    Map data = ModalRoute.of(context)?.settings.arguments as Map;

    // Set ScreenTimeOut
    if (SharedPreferencesManager().getScreenTimeout()) {
      KeepScreenOn.turnOff();
    } else {
      KeepScreenOn.turnOn();
    }

    return PopScope(
      // On Screen Exit, clear screenTimeout & Show Status bar
      onPopInvoked: (bool t) {
        KeepScreenOn.turnOff();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            // Add an IconButton at the top right corner
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    bool isScreenTimeout =
                        !SharedPreferencesManager().getScreenTimeout();
                    SharedPreferencesManager()
                        .setScreenTimeout(isScreenTimeout);
                    Misc.showAutoDismissSnackBar(
                        context,
                        isScreenTimeout
                            ? "Screen will turnoff automatically"
                            : "Screen will stay on until timer exit");
                    setState(() {});
                  },
                  icon: Icon(SharedPreferencesManager().getScreenTimeout()
                      ? Icons.lock_clock
                      : Icons.access_time)),
            ],
            title: Text(
              data["rituals"][habitIndex].url.toString().substring(
                  data["rituals"][habitIndex].url.toString().lastIndexOf("/") +
                      1),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: "NotoSans-Light",
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.black,
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    CircularCountDownTimer(
                      controller: countDownCtrlr,
                      duration:
                          data["rituals"][habitIndex].duration.toInt() * 60,
                      textStyle: TextStyle(
                          fontSize: (MediaQuery.of(context).size.width <
                                  MediaQuery.of(context).size.height)
                              ? (MediaQuery.of(context).size.width / 4)
                              : (MediaQuery.of(context).size.height / 4),
                          color: Colors.white,
                          fontFamily: "NotoSans-Light",
                          fontWeight: FontWeight.bold),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 1.5,
                      ringColor: darkColorScheme.primaryContainer,
                      fillColor: darkColorScheme.primary,
                      strokeWidth: 10.0,
                      isTimerTextShown: true,
                      isReverse: true,
                      strokeCap: StrokeCap.round,
                      isReverseAnimation: false,
                      autoStart: true,
                      onComplete: () {
                        // Mark Habit as Complete and save into hive
                        Ritual r = Boxes.getBox()
                            .get(data['rituals'][habitIndex].key)!;
                        r.complete = 1;
                        r.checkedOn = DateTime.now();
                        r.save();

                        // Play Complete Audio
                        if (data["rituals"][habitIndex].url != "/break") {
                          assetsAudioPlayer.open(
                            Audio("assets/audios/complete.mp3"),
                          );
                        }

                        // Move to Next habit / return to ritual screen
                        if (data["rituals"].length > 1) {
                          habitIndex++;
                          setState(() {});
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onStart: () {
                        if (data["rituals"][habitIndex].url != "/break") {
                          assetsAudioPlayer.open(
                            Audio("assets/audios/start.mp3"),
                          );
                        }
                      },
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == 0) {
                          return "Start";
                        } else {
                          return "${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds - duration.inMinutes * 60).toString().padLeft(2, '0')}";
                        }
                      },
                    ),
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (countDownCtrlr.isPaused.value) {
                countDownCtrlr.resume();
              } else {
                countDownCtrlr.pause();
              }
              setState(() {});
            },
            child:
                Icon(countDownCtrlr.isPaused.value ? Icons.play_arrow : Icons.pause),
          )),
    );
  }
}
