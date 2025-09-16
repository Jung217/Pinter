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
import 'package:ritual/services/shared_prefs.dart';
import 'package:ritual/services/widgets/image_picker.dart';
import 'package:ritual/services/notification_service.dart';

class Commit2Highlight extends StatefulWidget {
  const Commit2Highlight({super.key});

  @override
  State<Commit2Highlight> createState() => _Commit2HighlightState();
}

class _Commit2HighlightState extends State<Commit2Highlight> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  bool _init = false;

  // Card Background illustration path
  String cardBackgroundPath = Constants.noBackground;

  // Check to Schedule the highlight for the next day
  bool isHighlightPlanned = false;

  // Map of asset Illustrations
  Map cardIllustrations = {};

  // Check for duplicate Highlight
  bool isDuplicateHighlight = false;
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

    // A copy of appSetupTrackerHighlightCommit
    final appSetupTrackerHighlightCommit = !SharedPreferencesManager()
        .getAppSetupTracker(Constants.appSetupTrackerHighlightCommit);

    // Set the Highlight Commit Demo to complete
    SharedPreferencesManager()
        .setAppSetupTracker(Constants.appSetupTrackerHighlightCommit);

    // Focus the textField
    if (!appSetupTrackerHighlightCommit) {
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

                        // Cancel set notification
                        cancelNotification(data["ritual"].url.hashCode);

                        deleteHighlight(data['ritual']);
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
                  enable: appSetupTrackerHighlightCommit,
                  content:
                      Misc.spotlightText("Enter your highlight for the Day"),
                  spotlight: const SpotlightConfig(
                      builder: SpotlightRectBuilder(borderRadius: 10)),
                  child: TextField(
                    controller: _textFieldController,
                    focusNode: _textFieldFocusNode,
                    onChanged: (text) {
                      setState(() {
                        isDuplicateHighlight = Boxes.getBox().values.any(
                            (habit) => (habit.url.endsWith(text) &&
                                habit.type == Constants.typeHLight));
                        // TODO: Check for highlighs spanning multiple days and change the error message: Use Sprints for Highlights spanning multiple days
                        errorMessage =
                            isDuplicateHighlight ? "Duplicate Highlight" : "";
                      });
                    },
                    decoration: InputDecoration(
                        errorText: errorMessage,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              // TODO: Red border on duplicate Highlight
                              ),
                        ),
                        hintText: data['mode'] == "edit"
                            ? "Rename your Highlight ${data['uri'].replaceFirst('/', '')} to"
                            : "What's your latest Highlight"),
                  ),
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
                        enable: appSetupTrackerHighlightCommit,
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
                        enable: appSetupTrackerHighlightCommit,
                        content: Misc.spotlightText("Pick your favorite image"),
                        child: IconButton(
                          icon: const Icon(
                            Icons.image_search,
                          ),
                          onPressed: () => _getImage(data),
                        ),
                      ),
                      SpotlightAnt(
                        enable: appSetupTrackerHighlightCommit,
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
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Tomorrow's Highlight",
                          style: TextStyle(
                              fontSize: 20, fontFamily: "NotoSans-Light")),
                      SpotlightAnt(
                        enable: appSetupTrackerHighlightCommit,
                        content: Misc.spotlightText(
                            "Planning the highlight for tomorrow?"),
                        child: Checkbox(
                          value: isHighlightPlanned,
                          onChanged: (value) {
                            isHighlightPlanned = value!;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: ((_textFieldController.text.isNotEmpty ||
                                  data["mode"] == "edit") &&
                              !(_textFieldController.text.contains("/"))) &&
                          !isDuplicateHighlight,
                      child: FilledButton.tonal(
                        onPressed: () async {
                          if (data['mode'] == "new") {
                            DateTime now = DateTime.now();
                            final ritual = Ritual()
                              ..complete = 0

                              // Set the URL, Background and Type for the new Ritual
                              ..url = "/${_textFieldController.text}"
                              ..background = cardBackgroundPath
                              ..type = Constants.typeHLight

                              // Highlight expires(gets deleted) the next day or the day after
                              ..expiry = DateTime(
                                      now.year, now.month, now.day, 0, 0, 0, 0)
                                  .add(Duration(
                                      days: isHighlightPlanned ? 2 : 1));

                            final box = Boxes.getBox();
                            box.add(ritual);

                            // Setup Notification
                            await scheduleNotification(
                                "/${_textFieldController.text}".hashCode,
                                _textFieldController.text,
                                null,
                                "Your Highlight for the day",
                                false,
                                ritual.expiry!
                                    .subtract(const Duration(days: 1)));
                          } else {
                            Ritual r = data['ritual'];

                            if (_textFieldController.text.isNotEmpty) {
                              r.url = "/${_textFieldController.text}";
                            }

                            if ((cardBackgroundPath != r.background) &&
                                (cardBackgroundPath.isNotEmpty)) {
                              r.background = cardBackgroundPath;
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

  void deleteHighlight(Ritual r) {
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
