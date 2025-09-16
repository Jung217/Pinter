import 'dart:io';
import 'package:flutter/material.dart';

// Service
import 'package:ritual/services/boxes.dart';

/// Export the hive database file
Future<void> backupHiveBox<T>(String backupPath) async {
  final box = Boxes.getBox();
  final boxPath = box.path;

  try {
    File(boxPath!).copySync(
        "$backupPath/ritual.hive");
  } catch (_) {
    debugPrint("@data_shuttle: Export Exception Caught: $_");
  }
}

/// Import the Hive database file
Future<void> restoreHiveBox<T>(String backupPath) async {
  final box = Boxes.getBox();
  final boxPath = box.path;
  debugPrint("@data_shuttle: Box path: ${box.path}");
  await box.close();

  try {
    File(backupPath).copy(boxPath!);
  } catch (_) {
    debugPrint("Restore exception: $_");
  }
}
