import 'package:flutter/material.dart';

class Constants{
  // Type constants
  static const String typeRitual = "ritual";
  static const String typeSprint = "sprint";
  static const String typeHLight = "highlight";
  static const String typeHabits = "habit";

  // Habit constants
  static const String typeRHabit = "rHabit";
  static const String typeDHabit = "dHabit";
  static const String typeSHabit = "sHabit";
  static const String typeTHabit = "tHabit";

  // Card Background constant
  static const String noBackground = "default";

  // Application mode selection
  static const int modeLight = 0;
  static const int modeDark = 1;
  static const int modeAuto = 2;

  // Application Setup Order
  static const int appSetupTrackerGettingStartedScreen = 1;
  static const int appSetupTrackerHomeScreen = 2;
  static const int appSetupTrackerFab = 3;
  static const int appSetupTrackerHighlightCard = 4;
  static const int appSetupTrackerHighlightCommit = 5;
  static const int appSetupTrackerSprintCard = 6;
  static const int appSetupTrackerSprintCommit = 7;
  static const int appSetupTrackerRitualCard = 8;
  static const int appSetupTrackerRitualCommit = 9;
  static const int appSetupTrackerRitualScreen = 10;
  static const int appSetupTrackerHabitCommit = 11;
  static const int appSetupTrackerHabitCard = 12;
  static const int appSetupTrackerTimerScreen = 13;

  // Background Colors
  static const Color primaryColor = Color.fromARGB(255, 255, 255, 255);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  
  // Text Color
  static const Color primaryTextColor = Color.fromARGB(255, 0, 0, 0);
  // static const Color accentTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color accentTextColor = primaryTextColor;

  // Illustration Assets
  static const List<String> illustrations = ['assets/illustrations/1e60b.jpg', 'assets/illustrations/9f865.jpg', 'assets/illustrations/30aeb.jpg', 'assets/illustrations/49d26.jpg', 'assets/illustrations/53898.jpg', 'assets/illustrations/6b3b2.jpg', 'assets/illustrations/77d94.jpg', 'assets/illustrations/7eb9d.jpg', 'assets/illustrations/8bfc8.jpg', 'assets/illustrations/a6bce.jpg', 'assets/illustrations/afa61.jpg', 'assets/illustrations/b0f0c.jpg', 'assets/illustrations/c1ad9.jpg', 'assets/illustrations/ca32e.jpg', 'assets/illustrations/d7456.jpg', 'assets/illustrations/daf7b.jpg', 'assets/illustrations/f3d43.jpg', 'assets/illustrations/fef36.jpg'];

}