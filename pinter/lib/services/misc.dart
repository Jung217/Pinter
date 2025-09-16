/// Author: Ujwal N K
/// Created On: 2023 Dec, 28
/// Miscellaneous Services
library;

import 'package:flutter/material.dart';

import 'package:ritual/services/constants.dart';
import 'package:ritual/services/shared_prefs.dart';

class Misc {
  // Check for using dark background
  static bool isDark(BuildContext context) {
    debugPrint(
        "Returning: ${(((MediaQuery.of(context).platformBrightness == Brightness.dark) && (SharedPreferencesManager().getAppMode() == Constants.modeAuto)) || (SharedPreferencesManager().getAppMode() == Constants.modeDark))}");
    return (((MediaQuery.of(context).platformBrightness == Brightness.dark) &&
            (SharedPreferencesManager().getAppMode() == Constants.modeAuto)) ||
        (SharedPreferencesManager().getAppMode() == Constants.modeDark));
  }

  // SnackBar
  static void showAutoDismissSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static Widget spotlightText(String t) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 30),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Text(t,
                style: const TextStyle(
                    fontFamily: "NotoSans-Light", 
                    fontSize: 20,
                    color: Colors.white,
                  ))));
  }
}
