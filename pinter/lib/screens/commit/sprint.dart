import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Hive database packages
import 'package:ritual/model/ritual.dart';

// Services
import 'package:ritual/services/boxes.dart';
import 'package:ritual/services/misc.dart';
import 'package:ritual/services/widgets/date_picker.dart';
import 'package:ritual/services/shared_prefs.dart';
import 'package:ritual/services/constants.dart';
import 'package:ritual/services/widgets/image_picker.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

class Commit2Sprint extends StatefulWidget {
  const Commit2Sprint({super.key});

  @override
  State<Commit2Sprint> createState() => _Commit2SprintState();
}

class _Commit2SprintState extends State<Commit2Sprint> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  bool _init = false;

  DateTime? selectedDate;

  // Map of asset Illustrations
  String cardBackgroundPath = Constants.noBackground;

  // Illustrations
  Map cardIllustrations = {};

  // Error Message & duplicate sprint check
  String? errorMessage;
  bool isDuplicateSprint = false;

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

    // A copy of appSetupTrackerSprintCommit
    final appSetupTrackerSprintCommit = !SharedPreferencesManager()
        .getAppSetupTracker(Constants.appSetupTrackerSprintCommit);

    // Set the Highlight Commit Demo to complete
    SharedPreferencesManager()
        .setAppSetupTracker(Constants.appSetupTrackerSprintCommit);

    // Focus the textField / Enable SpotlightAnt
    if (!appSetupTrackerSprintCommit) {
      _textFieldFocusNode.requestFocus();
    }

    if (!_init) {
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

                        // Delete the user image
                        if ((data['ritual'].background !=
                                Constants.noBackground) &&
                            (!data['ritual']
                                .background
                                .contains("assets/illustrations/"))) {
                          await File(data['ritual'].background).delete();
                        }

                        deleteSprint(data['ritual']);
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
                  content: Misc.spotlightText("Enter your Sprint"),
                  enable: appSetupTrackerSprintCommit,
                  spotlight: const SpotlightConfig(
                      builder: SpotlightRectBuilder(borderRadius: 10)),
                  child: TextField(
                    controller: _textFieldController,
                    focusNode: _textFieldFocusNode,
                    onChanged: (text) {
                      setState(() {
                        isDuplicateSprint = Boxes.getBox().values.any((habit) =>
                            (habit.url.endsWith(text) &&
                                habit.type == Constants.typeSprint));
                        errorMessage =
                            isDuplicateSprint ? "Duplicate Sprint" : "";
                      });
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              // TODO: Red border on duplicate sprint
                              ),
                        ),
                        errorText: errorMessage,
                        hintText: data['mode'] == "edit"
                            ? "Rename your Sprint ${data['uri'].replaceFirst('/', '')} to"
                            : "What's your latest Sprint"),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sprint Until",
                      style:
                          TextStyle(fontSize: 20, fontFamily: "NotoSans-Light"),
                    ),
                    SpotlightAnt(
                      content: Misc.spotlightText(
                          "Choose the duration of the Sprint"),
                      spotlight: const SpotlightConfig(
                          builder: SpotlightRectBuilder(borderRadius: 10)),
                      enable: appSetupTrackerSprintCommit,
                      child: CustomDatePicker(
                        restorationId: "datepicker",
                        onDateSelected: handleDateSelected,
                        preSelectedDate: data['expiry'],
                      ),
                    )
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
                        enable: appSetupTrackerSprintCommit,
                        content: Misc.spotlightText(
                            "Choose form the best illustrations"),
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
                        enable: appSetupTrackerSprintCommit,
                        content:
                            Misc.spotlightText("Pick your favourite image"),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image_search,
                          ),
                          onPressed: () => _getImage(data),
                        ),
                      ),
                      SpotlightAnt(
                        enable: appSetupTrackerSprintCommit,
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
                      visible: ((!_textFieldController.text.contains("/")) &&
                              ((data["mode"] == "edit") ||
                                  (_textFieldController.text.isNotEmpty &&
                                      (selectedDate != null)))) &&
                          !isDuplicateSprint,
                      child: FilledButton.tonal(
                        onPressed: () {
                          if (data["mode"] == "new") {
                            final ritual = Ritual()
                              ..complete = 0
                              ..url = "/${_textFieldController.text}"
                              ..background = cardBackgroundPath
                              ..type = Constants.typeSprint
                              ..expiry = selectedDate;

                            final box = Boxes.getBox();
                            box.add(ritual);
                          } else {
                            // update the sprint name and expiry date in the database
                            Ritual r = data['ritual'];

                            if (_textFieldController.text.isNotEmpty) {
                              r.url = "/${_textFieldController.text}";
                            }

                            debugPrint(
                                "Change in cardBackgroundPath? $cardBackgroundPath");
                            if ((cardBackgroundPath != r.background) &&
                                (cardBackgroundPath.isNotEmpty)) {
                              r.background = cardBackgroundPath;
                            }

                            if ((selectedDate != r.expiry) &&
                                (selectedDate != null)) {
                              r.expiry = selectedDate;
                            }

                            r.save();
                          }

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

  // Callback function to receive the selected date
  void handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void deleteSprint(Ritual r) {
    Boxes.getBox().delete(r.key);
    Boxes.getBox().flush();

    Navigator.pop(context);
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
}
