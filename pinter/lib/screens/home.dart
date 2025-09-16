import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spotlight_ant/spotlight_ant.dart';

// Hive database packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ritual/model/ritual.dart';

// Services
import 'package:ritual/services/boxes.dart';
import 'package:ritual/services/constants.dart';
import 'package:ritual/services/misc.dart';
import 'package:ritual/services/ritual_icons.dart';
import 'package:ritual/services/shared_prefs.dart';
import 'package:ritual/services/widgets/fab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Map cardIllustrations = {};

class _HomeState extends State<Home> {
  // Hide Sprints & Highlights
  bool hideSprints = true;
  bool hideHighlights = true;

  // First car of type
  bool isFirstHlight = true;
  bool isFirstSprint = true;
  bool isFirstRitual = true;

  // Application Accent Color
  Color iconColor = const ColorScheme.dark().primary;

  // A copy of appSetupTracker for HighlightCard, SprintCard & RitualCard
  bool appSetupTrackerHighlightCard = true;
  bool appSetupTrackerSprintCard = true;
  bool appSetupTrackerRitualCard = true;

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
    // Set iconColor
    MediaQuery.of(context).platformBrightness == Brightness.dark
        ? const ColorScheme.dark().primary
        : const ColorScheme.light().primary;

    // A Copy of appSetupTrackerHomeScreen
    final appSetupTrackerHomeScreen = !SharedPreferencesManager()
        .getAppSetupTracker(Constants.appSetupTrackerHomeScreen);

    // Set the Home Screen Demo to complete
    SharedPreferencesManager()
        .setAppSetupTracker(Constants.appSetupTrackerHomeScreen);

    // Expandable FAB
    ExpandableFab fab = ExpandableFab(
        sprint: SharedPreferencesManager().getShowSprints(),
        highlight: SharedPreferencesManager().getShowHighlight());

    return SpotlightShow(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              (SharedPreferencesManager().getShowHighlight() ||
                      SharedPreferencesManager().getShowSprints())
                  ? "Home"
                  : "Rituals",
              style: const TextStyle(
                fontFamily: "NotoSans-Light",
              ),
            ),
            // backgroundColor: accentColor,
            shadowColor: Colors.black,
            elevation: 2,
            actions: <Widget>[
              GestureDetector(
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/settings');
                    // SetState for changes to reflect
                    setState(() {});
                  },
                ),
                onLongPress: () {},
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: SharedPreferencesManager().getShowHighlight(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      hideHighlights = !hideHighlights;
                      setState(() {});
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(17.0, 16.0, 17.0, 16.0),
                      child: SpotlightAnt(
                        enable: appSetupTrackerHomeScreen,
                        // index: 2,
                        spotlight: const SpotlightConfig(
                            builder: SpotlightRectBuilder(borderRadius: 10)),
                        content: Misc.spotlightText("Tap to hide Highlights"),
                        child: Stack(
                          children: [
                            Text(
                              "Highlights",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: "NotoSans",
                                  decoration: hideHighlights
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough),
                            ),
                            // Don't hide the icon, make it transparent, otherwise GestureDetector won't work
                            Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(CustomIcons.lightbulbOutline,
                                      color: hideHighlights
                                          ? iconColor.withAlpha(2000)
                                          : iconColor.withAlpha(0)),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: SharedPreferencesManager().getShowHighlight() &&
                      hideHighlights,
                  child: ValueListenableBuilder<Box<Ritual>>(
                    valueListenable: Boxes.getBox().listenable(),
                    builder: (context, box, _) {
                      final contents = box.values.toList().cast<Ritual>();
                      var rituals = <Ritual>[];
                      for (var ritual in contents) {
                        DateTime now = DateTime.now();
                        DateTime today =
                            DateTime(now.year, now.month, now.day, 0, 0, 0, 0)
                                .add(const Duration(days: 1));
                        if ((ritual.type == Constants.typeHLight) &&
                            (ritual.expiry == today)) {
                          rituals.add(ritual);
                        }
                      }
                      // Sort alphabetically
                      rituals.sort((a, b) => a.url.compareTo(b.url));

                      return buildContent(rituals, type: Constants.typeHLight);
                    },
                  ),
                ),
                Visibility(
                  visible: SharedPreferencesManager().getShowSprints(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      hideSprints = !hideSprints;
                      setState(() {});
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(17.0, 16.0, 17.0, 16.0),
                      child: SpotlightAnt(
                        enable: appSetupTrackerHomeScreen,
                        // index: 3,
                        spotlight: const SpotlightConfig(
                            builder: SpotlightRectBuilder(borderRadius: 10)),
                        content: Misc.spotlightText("Tap to hide Sprints"),
                        child: Stack(children: [
                          Text(
                            "Sprints",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: "NotoSans",
                                decoration: hideSprints
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough),
                          ),
                          // Don't hide the icon, make it transparent, otherwise GestureDetector won't work
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(CustomIcons.directionsRun,
                                      color: hideSprints
                                          ? iconColor.withAlpha(200)
                                          : iconColor.withAlpha(0))))
                        ]),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: SharedPreferencesManager().getShowSprints() &&
                      hideSprints,
                  child: ValueListenableBuilder<Box<Ritual>>(
                    valueListenable: Boxes.getBox().listenable(),
                    builder: (context, box, _) {
                      final contents = box.values.toList().cast<Ritual>();
                      var rituals = <Ritual>[];
                      for (var ritual in contents) {
                        if (ritual.type == Constants.typeSprint) {
                          rituals.add(ritual);
                        }
                      }
                      // Sort by expiry
                      rituals.sort((a, b) => a.expiry!.compareTo(b.expiry!));

                      return buildContent(rituals, type: Constants.typeSprint);
                    },
                  ),
                ),
                Visibility(
                  visible: SharedPreferencesManager().getShowHighlight() ||
                      SharedPreferencesManager().getShowSprints(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17.0, 16.0, 17.0, 16.0),
                    child: Stack(children: [
                      const Text(
                        "Rituals",
                        style: TextStyle(fontSize: 22, fontFamily: "NotoSans"),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(CustomIcons.fire,
                                color: iconColor.withAlpha(200)),
                          ))
                    ]),
                  ),
                ),
                Visibility(
                  visible: ((SharedPreferencesManager().getShowHighlight() ==
                          false) &&
                      (SharedPreferencesManager().getShowSprints() == false)),
                  child: const SizedBox(height: 20),
                ),
                ValueListenableBuilder<Box<Ritual>>(
                  valueListenable: Boxes.getBox().listenable(),
                  builder: (context, box, _) {
                    final contents = box.values.toList().cast<Ritual>();
                    var rituals = <Ritual>[];

                    // Get the list of Rituals
                    for (var ritual in contents) {
                      if (ritual.type == Constants.typeRitual) {
                        rituals.add(ritual);
                      }
                    }

                    // Sort by time
                    rituals.sort((a, b) {
                      if (a.time["hour"] != b.time["hour"]) {
                        return a.time["hour"] - b.time["hour"];
                      } else {
                        return a.time["minute"] - b.time["minute"];
                      }
                    });

                    // On first to type add SpotlightAnt
                    return buildContent(rituals);
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: fab),
    );
  }

  Widget buildContent(List<Ritual> rituals,
      {String type = Constants.typeRitual}) {
    if (rituals.isEmpty) {
      // Return an empty widget on no cards.
      return const SizedBox(height: 0, width: 0);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final ritual in rituals) buildCard(context, ritual, type: type),
        ],
      );
    }
  }

  Widget buildCard(BuildContext context, Ritual ritual,
      {String type = Constants.typeRitual}) {
    // Mark the appSetupTracker as done for type
    if (type == Constants.typeRitual) {
      appSetupTrackerRitualCard = !SharedPreferencesManager()
          .getAppSetupTracker(Constants.appSetupTrackerRitualCard);
      SharedPreferencesManager()
          .setAppSetupTracker(Constants.appSetupTrackerRitualCard);
    } else if (type == Constants.typeSprint) {
      appSetupTrackerSprintCard = !SharedPreferencesManager()
          .getAppSetupTracker(Constants.appSetupTrackerSprintCard);

      SharedPreferencesManager()
          .setAppSetupTracker(Constants.appSetupTrackerSprintCard);
    } else if (type == Constants.typeHLight) {
      appSetupTrackerHighlightCard = !SharedPreferencesManager()
          .getAppSetupTracker(Constants.appSetupTrackerHighlightCard);

      SharedPreferencesManager()
          .setAppSetupTracker(Constants.appSetupTrackerHighlightCard);
    }

    // Calculate the percentage complete of ritual
    if (type == Constants.typeRitual) {
      final rituals = Boxes.getBox().values.toList().cast<Ritual>();

      int habits = 0;
      int complete = 0;

      for (Ritual r in rituals) {
        if (r.url.contains(ritual.url) && (r.type!.contains("habit"))) {
          // Higher priority, higher complete
          if (!r.type!.contains(Constants.typeDHabit)) {
            habits += (5 - r.priority);
          }

          if (r.complete == 1) {
            if (r.type!.contains(Constants.typeDHabit)) {
              habits += (5 - r.priority);
              complete -= (5 - r.priority);
            } else {
              complete += (5 - r.priority);
            }
          }
        }
      }

      ritual.complete =
          complete >= 0 ? ((habits == 0) ? 1 : complete / habits) : 0;
      ritual.save();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(60.0, 0, 5, 0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (type == Constants.typeRitual) {
            Navigator.pushNamed(context, "/rituals", arguments: {
              "background": ritual.background!,
              "ritual": ritual,
            });
          } else {
            // Mark the Highlight & Sprints as done
            if (ritual.complete == 0) {
              setState(() {
                ritual.complete = 1;
                ritual.checkedOn = DateTime.now();
                ritual.save();
              });
            } else {
              // Don't uncheck habits
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: GestureDetector(
                      child: const Text('Trying to uncheck?'),
                      // DEVELOPER FEATURE
                      onDoubleTap: () {
                        ritual.complete = 0;
                      },
                    ),
                    content: const Text(
                        'Commitments fullfilled; Why unmark accomplishments?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Makes Sense'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        onLongPress: () {
          // Display edit and delete options for highlights & sprints
          Navigator.pushNamed(context, "/commit/${ritual.type}", arguments: {
            "uri": ritual.url,
            "background": ritual.background,
            "mode": "edit",
            "time": ritual.time,
            "expiry": ritual.expiry,
            "ritual": ritual
          });
        },
        child: SpotlightAnt(
          spotlight: const SpotlightConfig(
              builder: SpotlightRectBuilder(borderRadius: 10)),
          enable: ((type == Constants.typeHLight)
              ? appSetupTrackerHighlightCard
              : (type == Constants.typeSprint
                  ? appSetupTrackerSprintCard
                  : appSetupTrackerRitualCard)),
          content: ((type == Constants.typeHLight)
              ? Misc.spotlightText(
                  "Tap this card to mark the highlight complete")
              : (type == Constants.typeSprint
                  ? Misc.spotlightText(
                      "Tap this card to mark the sprint complete")
                  : Misc.spotlightText(
                      "Tap this card to open the Ritual page"))),
          child: SizedBox(
            height: 100,
            child: Card(
              color: Colors.transparent,
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Stack(
                  // Use a Stack to overlay the image and text.
                  children: [
                    // Background
                    if (ritual.background != Constants.noBackground)
                      ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            // Set greyscale intensity if Saturate Cards Enabled
                            SharedPreferencesManager().getSaturateCard() == true
                                ? Colors.grey.withOpacity((1 - ritual.complete))
                                : Colors.white.withOpacity(0),
                            // Use the saturation blend mode to create greyscale effect
                            BlendMode.saturation,
                          ),
                          child: (ritual.background!
                                  .contains("assets/illustrations")
                              ? Image.asset(ritual.background!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200)
                              : Image.file(File(ritual.background!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200)))
                    else
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          // Set greyscale intensity if Saturate Cards Enabled
                          SharedPreferencesManager().getSaturateCard() == true
                              ? Colors.grey.withOpacity((1 - ritual.complete))
                              : Colors.white.withOpacity(0),
                          // Use the saturation blend mode to create greyscale effect
                          BlendMode.saturation,
                        ),
                        child: Image.asset(
                          "assets/illustrations/$type.jpg",
                          fit: BoxFit.cover,
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),

                    // Text on top of the image.
                    Positioned(
                      left: 24,
                      top: 8,
                      right: 24,
                      bottom: 8,
                      child: Text(
                        ritual.url.replaceAll("/", ""),
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0.2, 0.2),
                                blurRadius: 3.0,
                                color: Color.fromARGB(15, 0, 0, 0),
                              ),
                              Shadow(
                                offset: Offset(0.2, 0.2),
                                blurRadius: 8.0,
                                color: Colors.black,
                              ),
                            ],
                            fontFamily: "NotoSans-SemiBold"),
                      ),
                    ),

                    // Text to the bottom of the image.
                    Visibility(
                      visible: type == Constants.typeRitual,
                      child: Positioned(
                        left: 24,
                        top: 48,
                        right: 24,
                        bottom: 8,
                        child: Text(
                          "${ritual.time['hour'] > 12 ? ritual.time['hour'] - 12 : ritual.time['hour']}:${ritual.time['minute'] < 10 ? '0${ritual.time['minute']}' : ritual.time['minute']} ${ritual.time['hour'] >= 12 ? "PM" : "AM"}",
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0.2, 0.2),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(15, 0, 0, 0),
                                ),
                                Shadow(
                                  offset: Offset(0.2, 0.2),
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                ),
                              ],
                              fontFamily: "NotoSans-Light"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
