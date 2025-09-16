/// Author: Ujwal N K
/// Created on: 2023, Jan 02
/// Getting Started Screen
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Screens
import 'package:ritual/screens/home.dart';

// Services
import 'package:ritual/services/constants.dart';
import 'package:ritual/services/ritual_icons.dart';
import 'package:ritual/services/shared_prefs.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  static const Widget paddingBox = SizedBox(height: 20, width: double.infinity);
  int guideIndex = 0;

  static const List appModeIcon = <Icon>[
    Icon(Icons.sunny),
    Icon(Icons.dark_mode),
    Icon(Icons.auto_mode_rounded)
  ];

  List<Widget> guideScreenContent = [];

  @override
  void initState() {
    // Allow only portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set the Getting Started Demo to complete
    SharedPreferencesManager().setAppSetupTracker(Constants.appSetupTrackerGettingStartedScreen);

    guideScreenContent = [
      // Ritual
      Scaffold(
          appBar: AppBar(
            title: const Text("Ritual"),
            actions: [
              IconButton(
                  icon: const Icon(Icons.navigate_next_rounded),
                  onPressed: () {
                    guideIndex++;
                    setState(() {});
                  })
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(children: <Widget>[
              Image.asset('assets/icons/icon.png'),
              paddingBox,
              const Text(
                  "A Comprehensive Habit Tracker, \"The Free & Open Source Habit tracker\" Designed to help you track your daily Routines, Highlights, and Sprints \n\nClick the button on the top right corner to explore the app"),
            ]),
          )),

      // Rituals
      Scaffold(
          appBar: makeAppBar("R"),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(children: <Widget>[
              getHeadingwithIcon("Rituals", const Icon(CustomIcons.fire)),
              paddingBox,
              const Text(
                  "Rituals are sequences of habits to be completed in an order at predetermined times. \n\nEach ritual can consist of multiple types of habits, creating a routine to follow."),
            ]),
          )),

      // Rituals
      Scaffold(
          appBar: makeAppBar("RH"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(children: <Widget>[
                getHeadingwithIcon("Rituals", const Icon(CustomIcons.fire)),
                paddingBox,
                const Text(
                    "Rituals are sequences of habits to be completed in an order at predetermined times. \n\nEach ritual can consist of multiple types of habits, creating a routine to follow."),
                paddingBox,
                paddingBox,
                getHeadingwithIcon("Highlights", const Icon(CustomIcons.lightbulbOutline)),
                paddingBox,
                const Text(
                    "Highlights are your daily goals, pinpointing one task for intense focus. \n\nThey're like the EAT YOUR FROG tasks—best done, ideally, first thing in the morning to kickstart your day with a sense of accomplishment."),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Enable Highlights",
                          style: TextStyle(fontFamily: "NotoSans-Light")),
                      Checkbox(
                        value: SharedPreferencesManager().getShowHighlight(),
                        onChanged: (value) async {
                          await SharedPreferencesManager()
                              .setShowHighlight(value!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          )),

      // Sprints
      Scaffold(
          appBar: makeAppBar("RHS"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(children: <Widget>[
                getHeadingwithIcon("Rituals", const Icon(CustomIcons.fire)),
                paddingBox,
                const Text(
                    "Rituals are sequences of habits to be completed in an order at predetermined times. \n\nEach ritual can consist of multiple types of habits, creating a routine to follow."),
                paddingBox,
                paddingBox,
                getHeadingwithIcon("Highlights", const Icon(CustomIcons.lightbulbOutline)),
                paddingBox,
                const Text(
                    "Highlights are your daily goals, pinpointing one task for intense focus. \n\nThey're like the EAT YOUR FROG tasks—best done, ideally, first thing in the morning to kickstart your day with a sense of accomplishment."),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Enable Highlights",
                          style: TextStyle(fontFamily: "NotoSans-Light")),
                      Checkbox(
                        value: SharedPreferencesManager().getShowHighlight(),
                        onChanged: (value) async {
                          await SharedPreferencesManager()
                              .setShowHighlight(value!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                paddingBox,
                paddingBox,
                getHeadingwithIcon("Sprints", const Icon(CustomIcons.directionsRun)),
                paddingBox,
                const Text(
                    "Think of a sprint as a goal you work on for a stretch of time, whether it's a few days, weeks, or months. \n\nWhile Rituals are done day after day, and highlight focuses on one day, forming the ends of a spectrum, Sprints fall right in between. \n\nIt's a task that needs consistency to see results. While you can do it any time during the day, doing it at the same time daily helps achieve better outcomes."),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Enable Sprints",
                          style: TextStyle(fontFamily: "NotoSans-Light")),
                      Checkbox(
                        value: SharedPreferencesManager().getShowSprints(),
                        onChanged: (value) async {
                          await SharedPreferencesManager().setShowSprints(value!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          )),

      // Two Day Rule & Saturate Cards
      Scaffold(
        appBar: makeAppBar("Features"),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              getHeading("2 Day Rule"),
              paddingBox,
              const Text(
                  "Make a commitment to never skip a habit more than one day in a row. \n\nLife happens, so flexibility is key. But with the 2-Day Rule, you'll always bounce back stronger. This simple rule creates a powerful momentum that fuels your motivation and helps you achieve amazing results"),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Enable Two Day Rule",
                        style: TextStyle(fontFamily: "NotoSans-Light")),
                    Checkbox(
                      value: SharedPreferencesManager().getTwoDayRule(),
                      onChanged: (value) async {
                        await SharedPreferencesManager().setTwoDayRule(value!);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              paddingBox,
              paddingBox,
            ],
          ),
        ),
      ),

      // "Two Day Rule":
      Scaffold(
        appBar: makeAppBar("Features"),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              getHeading("2 Day Rule"),
              paddingBox,
              const Text(
                  "Make a commitment to never skip a habit more than one day in a row. \n\nLife happens, so flexibility is key. But with the 2-Day Rule, you'll always bounce back stronger. This simple rule creates a powerful momentum that fuels your motivation and helps you achieve amazing results"),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Enable Two Day Rule",
                        style: TextStyle(fontFamily: "NotoSans-Light")),
                    Checkbox(
                      value: SharedPreferencesManager().getTwoDayRule(),
                      onChanged: (value) async {
                        await SharedPreferencesManager().setTwoDayRule(value!);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              paddingBox,
              paddingBox,
              getHeading("Saturate Cards"),
              paddingBox,
              const Text(
                  "The color of your Ritual cards changes based on your progress. \n\nThe more habits you complete and the higher their priority, the more vibrant the card becomes. It's a visual celebration of your achievements, making it fun and easy to track your success."),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text("Make my tracking vibrant",
                        style: TextStyle(fontFamily: "NotoSans-Light")),
                    Checkbox(
                      value: SharedPreferencesManager().getSaturateCard(),
                      onChanged: (value) async {
                        await SharedPreferencesManager().setSaturateCard(value!);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Regular Habits
      Scaffold(
          appBar: makeAppBar("Habits"),
          body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  getHeading("Regular Habits"),
                  paddingBox,
                  const Text(
                      "These are your daily tasks that you tick off as you complete them. \n\nThey have a set duration, and you can use the built-in timer to track your progress and mark them as done. It's a great way to stay on top of your daily routine effortlessly."),
                  paddingBox,
                  Image.network(
                    "https://ujwalnk.github.io/Ritual/network-img/rhabits-cropped.png",
                    fit: BoxFit.cover,
                  ),
                ]),
              ))),

      // dHabits
      Scaffold(
          appBar: makeAppBar("Habits"),
          body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  getHeading("deHabits"),
                  paddingBox,
                  const Text(
                      "Sometimes, becoming better means letting go of certain habits. \n\ndeHabits are those you're trying to break or steer clear of to improve yourself. You can track these to monitor your progress in avoiding them and building a healthier lifestyle."),
                  paddingBox,
                  Image.network(
                      "https://ujwalnk.github.io/Ritual/network-img/dhabit-cropped.png"),
                  paddingBox,
                  paddingBox,
                  getHeading("Regular Habits"),
                  paddingBox,
                  const Text(
                      "These are your daily tasks that you tick off as you complete them. \n\nThey have a set duration, and you can use the built-in timer to track your progress and mark them as done. It's a great way to stay on top of your daily routine effortlessly."),
                  paddingBox,
                  Image.network(
                    "https://ujwalnk.github.io/Ritual/network-img/rhabits-cropped.png",
                    fit: BoxFit.cover,
                  ),
                ]),
              ))),

      // Stack Habits
      Scaffold(
          appBar: makeAppBar("Habits"),
          body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  getHeading("Stack Habits"),
                  paddingBox,
                  const Text(
                      "These habits embrace the power of the 1% rule, nudging you to improve by 1% every day."),
                  paddingBox,
                  Image.network(
                      "https://ujwalnk.github.io/Ritual/network-img/shabit-improvement.jpg"),
                  paddingBox,
                  const Text(
                      "Over a year, this consistent growth strategy compounds, leading to nearly 30% improvement overall. They're small daily commitments that, over time, make a remarkable difference in your life, helping you steadily progress towards your goals."),
                  paddingBox,
                  Image.network(
                      "https://ujwalnk.github.io/Ritual/network-img/shabit-cropped.png"),
                  paddingBox,
                  paddingBox,
                  getHeading("deHabits"),
                  paddingBox,
                  const Text(
                      "Sometimes, becoming better means letting go of certain habits. \n\ndeHabits are those you're trying to break or steer clear of to improve yourself. You can track these to monitor your progress in avoiding them and building a healthier lifestyle."),
                  paddingBox,
                  Image.network(
                      "https://ujwalnk.github.io/Ritual/network-img/dhabit-cropped.png"),
                  paddingBox,
                  paddingBox,
                  getHeading("Regular Habits"),
                  paddingBox,
                  const Text(
                      "These are your daily tasks that you tick off as you complete them. \n\nThey have a set duration, and you can use the built-in timer to track your progress and mark them as done. It's a great way to stay on top of your daily routine effortlessly."),
                  paddingBox,
                  Image.network(
                    "https://ujwalnk.github.io/Ritual/network-img/rhabits-cropped.png",
                    fit: BoxFit.cover,
                  ),
                ]),
              ))),

      // "Set App Theme":
      Scaffold(
          appBar: makeAppBar("Set App Theme"),
          body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  // App Theme Toggle
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text("App Theme",
                            style: TextStyle(fontFamily: "NotoSans-Light")),
                        IconButton(
                            onPressed: () {
                              int currentAppMode =
                                  SharedPreferencesManager().getAppMode() + 1;
                              currentAppMode =
                                  currentAppMode >= 3 ? 0 : currentAppMode;

                              SharedPreferencesManager()
                                  .setAppMode(currentAppMode);
                              setState(() {});
                            },
                            icon: appModeIcon[
                                SharedPreferencesManager().getAppMode()])
                      ],
                    ),
                  ),
                ],
              ))),
    ];

    return guideScreenContent[guideIndex];
  }

  Widget getHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 32,
        fontFamily: "NotoSans-Light",
      ),
    );
  }

  Widget getHeadingwithIcon(String text, Icon i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17.0, 16.0, 0, 16.0),
      child: Stack(
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 22, fontFamily: "NotoSans-Light"),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: i,
              ))
        ],
      ),
    );
  }

  PreferredSizeWidget makeAppBar(String title) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.navigate_before_rounded),
        onPressed: () {
          guideIndex--;
          setState(() {});
        },
      ),
      title: Text(title),
      actions: [
        IconButton(
            icon: const Icon(Icons.navigate_next_rounded),
            onPressed: () {
              guideIndex++;
              if (guideIndex == (guideScreenContent.length)) {
                // Set init as complete
                SharedPreferencesManager().setAppInit(1);

                // Navigate to the home page if appInit otherwise to GettingStarted
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Home(),
                  settings: const RouteSettings(name: "Home"),
                ));
              } else {
                setState(() {});
              }
            })
      ],
    );
  }
}
