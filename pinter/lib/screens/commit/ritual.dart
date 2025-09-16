import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

// Hive database packages
import 'package:ritual/model/ritual.dart';

// Services
import 'package:ritual/services/boxes.dart';
import 'package:ritual/services/constants.dart';
import 'package:ritual/services/misc.dart';
import 'package:ritual/services/notification_service.dart';
import 'package:ritual/services/widgets/image_picker.dart';
import 'package:ritual/services/widgets/time_picker.dart';
import 'package:ritual/services/shared_prefs.dart';

class Commit2Ritual extends StatefulWidget {
  const Commit2Ritual({super.key});

  @override
  State<Commit2Ritual> createState() => _Commit2RitualState();
}

class _Commit2RitualState extends State<Commit2Ritual> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  bool _init = false;

  // Map of Card asset Illustrations
  Map cardIllustrations = {};

  // Ritual TimeofDay - when the Ritual should be done
  TimeOfDay selectedTime = TimeOfDay.now();

  // Card Background Illustration path
  String cardBackgroundPath = Constants.noBackground;

  // Duplicate Ritual check & Error Message
  bool isDuplicateRitual = false;
  String? errorMessage;

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
    // Get data from parent screen
    Map data = ModalRoute.of(context)?.settings.arguments as Map;

    // A copy of appSetupTrackerRitualCommit
    final appSetupTrackerRitualCommit = !SharedPreferencesManager()
        .getAppSetupTracker(Constants.appSetupTrackerRitualCommit);

    // Set the Ritual Commit Demo to complete
    SharedPreferencesManager()
        .setAppSetupTracker(Constants.appSetupTrackerRitualCommit);

    // Focus the textField
    if (!appSetupTrackerRitualCommit) {
      _textFieldFocusNode.requestFocus();
    }

    if (!_init) {
      selectedTime = (data['time'] == null)
          ? TimeOfDay.now()
          : TimeOfDay(
              hour: data['time']['hour'], minute: data['time']['minute']);
      _init = !_init;

      // Get the background used for the card
      if ((data['ritual'] == null)) {
        cardBackgroundPath = Constants.noBackground;
      } else if (data['ritual'] != null) {
        cardBackgroundPath = data["ritual"].background;
      }
    }

    // Precache card illustrations
    for (var image in Constants.illustrations) {
      cardIllustrations.addAll({
        image: Image.asset(
          image,
          fit: BoxFit.cover,
          // width: double.infinity,
          height: 200,
        )
      });
      precacheImage(cardIllustrations[image].image, context);
    }

    return SpotlightShow(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Commit",
              style: TextStyle(fontFamily: "NotoSans-Light"),
            ),
            actions: data['mode'] == "edit"
                ? <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        debugPrint("@Ritual: Deleting Ritual");

                        // Delete the image file
                        if ((data['ritual'].background !=
                                Constants.noBackground) &&
                            !(data["ritual"]
                                .background
                                .toString()
                                .contains("assets/illustrations"))) {
                          await File(data['ritual'].background).delete();
                        }

                        deleteRitual(data['uri']);
                      },
                    )
                  ]
                : [],
          ),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "Commit to",
                  style: TextStyle(fontSize: 20, fontFamily: "NotoSans-Light"),
                ),
                const SizedBox(height: 30),
                SpotlightAnt(
                  content: Misc.spotlightText("Enter a name for your Ritual"),
                  enable: appSetupTrackerRitualCommit,
                  spotlight: const SpotlightConfig(
                      builder: SpotlightRectBuilder(borderRadius: 10)),
                  child: TextField(
                    controller: _textFieldController,
                    focusNode: _textFieldFocusNode,
                    decoration: InputDecoration(
                        errorText: errorMessage,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              // TODO: Red border on duplicate habit
                              ),
                        ),
                        hintText: data['mode'] == "new"
                            ? "What would you like to call your amazing Ritual"
                            : "Rename your Ritual ${data['uri'].replaceFirst('/', '')} to"),
                    onChanged: (text) => setState(() {
                      isDuplicateRitual = Boxes.getBox()
                          .values
                          .any((habit) => habit.url.endsWith("/$text/"));
                      errorMessage =
                          isDuplicateRitual ? "Duplicate Ritual" : "";
                    }),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Start Ritual at",
                      style:
                          TextStyle(fontSize: 20, fontFamily: "NotoSans-Light"),
                    ),
                    SpotlightAnt(
                      spotlight: const SpotlightConfig(
                          builder: SpotlightRectBuilder(borderRadius: 10)),
                      content:
                          Misc.spotlightText("Pick a time for your Ritual"),
                      enable: appSetupTrackerRitualCommit,
                      child: TimePicker(
                          key: const Key("key_timepicker"),
                          onTimeSelected: handleTimeSelected,
                          selectedTime: selectedTime),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "A Background",
                      style:
                          TextStyle(fontSize: 20, fontFamily: "NotoSans-Light"),
                    ),
                    Row(children: [
                      SpotlightAnt(
                        enable: appSetupTrackerRitualCommit,
                        content: Misc.spotlightText(
                            "Choose from the best illustrations"),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomImagePicker(
                                  onImageSelected: (String selectedImage) {
                                    cardBackgroundPath = selectedImage;
                                    debugPrint(
                                        "@ritual: Image selected: $selectedImage");
                                  },
                                  cardIllustrations: cardIllustrations,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SpotlightAnt(
                        enable: appSetupTrackerRitualCommit,
                        content: Misc.spotlightText("Pick your favorite image"),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image_search,
                          ),
                          onPressed: () => _getImage(data),
                        ),
                      ),
                      SpotlightAnt(
                        enable: appSetupTrackerRitualCommit,
                        content: Misc.spotlightText("Use default illustration"),
                        child: IconButton(
                          icon: const Icon(
                            Icons.broken_image,
                          ),
                          onPressed: () =>
                              cardBackgroundPath = Constants.noBackground,
                        ),
                      ),
                    ])
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: ((_textFieldController.text.isNotEmpty ||
                                  (data['mode'] == "edit")) &&
                              !_textFieldController.text.contains("/")) &&
                          !isDuplicateRitual,
                      child: FilledButton.tonal(
                        onPressed: () async {
                          // Get boxes
                          final box = Boxes.getBox();

                          if (data['mode'] == "new") {
                            // Adding new Ritual
                            final ritual = Ritual()
                              ..complete = 0
                              ..url = "/${_textFieldController.text}"
                              ..background = cardBackgroundPath
                              ..type = Constants.typeRitual
                              ..time = {
                                "hour": selectedTime.hour,
                                "minute": selectedTime.minute
                              };

                            box.add(ritual);

                            // Schedule Notification
                            await scheduleNotification(
                                "/${_textFieldController.text}".hashCode,
                                _textFieldController.text,
                                TimeOfDay(
                                    hour: selectedTime.hour,
                                    minute: selectedTime.minute),
                                "It's time for ${ritual.url.replaceAll("/", "")}",
                                true,
                                null);
                          } else {
                            // Editing a pre-existing Ritual

                            // Cancel previous notification
                            await cancelNotification(data["uri"].hashCode);

                            // Get all rituals
                            final contents = box.values.toList().cast<Ritual>();

                            for (Ritual ritual in contents) {
                              // Edit time and name of ritual
                              if (ritual.url.contains(data['uri']) &&
                                  (ritual.type!
                                          .contains(Constants.typeHabits) ||
                                      ritual.type == Constants.typeRitual)) {
                                debugPrint(
                                    "@ritual: Renaming ritual ${ritual.url} to /${_textFieldController.text}");
                                if (_textFieldController.text.isNotEmpty) {
                                  ritual.url = ritual.url.replaceAll(
                                      data['uri'],
                                      "/${_textFieldController.text}");
                                }
                                if (cardBackgroundPath.isNotEmpty) {
                                  ritual.background = cardBackgroundPath;
                                }
                                ritual.time = {
                                  "hour": selectedTime.hour,
                                  "minute": selectedTime.minute
                                };

                                ritual.save();
                                debugPrint(
                                    "@ritual: Renamed to: ${ritual.url}");
                              }
                            }
                          }

                          // Schedule Notification
                          await scheduleNotification(
                              "/${_textFieldController.text}".hashCode,
                              _textFieldController.text,
                              TimeOfDay(
                                  hour: selectedTime.hour,
                                  minute: selectedTime.minute),
                              "Time for Ritual",
                              true,
                              null);

                          // Pop the screen
                          Navigator.pop(context);
                        },
                        child: const Text("Commit",
                            style: TextStyle(
                                fontFamily: "NotoSans-Light", fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _getImage(Map data) async {
    // Pick an image from the user gallery
    ImagePicker imagePicker = ImagePicker();
    final imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      // Get the application directory
      final String appDirPath = (await getApplicationDocumentsDirectory()).path;

      setState(() {
        // int fileNameIndex = imageFile.path.lastIndexOf("/");
        int fileExtensionIndex = imageFile.path.lastIndexOf(".");

        // cardBackgroundPath: <app_folder>/images/<current_file_sequence>.<image_extension>
        if (data['mode'] == "new") {
          cardBackgroundPath =
              "$appDirPath/images/${SharedPreferencesManager().getFileSequence()}${imageFile.path.substring(fileExtensionIndex)}";

          // Increment the file numbering sequence
          SharedPreferencesManager().setFileSequence(
              SharedPreferencesManager().getFileSequence() + 1);
        } else if ((data['mode'] == "edit") &&
            (data["background"] != Constants.noBackground)) {
          cardBackgroundPath = data['background'];

          // On image replace, needs a cache refresh
          imageCache.clearLiveImages();
        } else {
          cardBackgroundPath =
              "$appDirPath/images/${SharedPreferencesManager().getFileSequence()}${imageFile.path.substring(fileExtensionIndex)}";

          // Increment the file numbering sequence
          SharedPreferencesManager().setFileSequence(
              SharedPreferencesManager().getFileSequence() + 1);
        }
      });

      File imageFileTemp = File(imageFile.path);
      try {
        // Create directory if not exist
        Directory("$appDirPath/images").createSync(recursive: true);

        // Copy the source file to internal memory
        await imageFileTemp.copy(cardBackgroundPath);

        // Check if the file was successfully copied
        if (File("$appDirPath$cardBackgroundPath").existsSync()) {
          debugPrint('File copied to: $cardBackgroundPath');
        } else {
          debugPrint('Failed to copy the file.');
        }
      } catch (e) {
        // Handle any errors that may occur during the copy operation
        debugPrint('Error copying the file: $e');
      }

      // imageFile.saveTo(cardBackgroundPath);
      debugPrint("@ritual: CardbackgroundPath: $cardBackgroundPath");
    } else {
      // Set it to default value to show white background
      cardBackgroundPath = Constants.noBackground;
    }
  }

  /// Update the selected time
  void handleTimeSelected(TimeOfDay time) {
    setState(() {
      debugPrint("Setting time to $time");
      selectedTime = time;
    });
  }

  /// Delete the current ritual & habits
  void deleteRitual(String currentRitualURL) {
    final box = Boxes.getBox();

    // Get all rituals
    final contents = box.values.toList().cast<Ritual>();

    for (var ritual in contents) {
      // Delete all rituals having the same URL
      if ((ritual.type!.contains(Constants.typeHabits) ||
              ritual.type == Constants.typeRitual) &&
          ritual.url.contains(currentRitualURL)) {
        box.delete(ritual.key);
      }
    }

    // Return to home screen
    Navigator.of(context).popUntil(ModalRoute.withName("Home"));
  }
}
