import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  // Singleton instance
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._internal();

  late SharedPreferences _prefs;

  factory SharedPreferencesManager() {
    return _instance;
  }

  SharedPreferencesManager._internal();

  static const String showHighlight = 'a';
  static const String showSprints = 'b';
  static const String twoDayRule = 'c';
  static const String fileSequence = 'd';
  static const String appMode = 'e';
  static const String colorizeHabitText = 'f';
  static const String saturateCards = 'g';
  static const String screenTimeout = 'i';
  static const String appInit = 'j';
  static const String breakTime = 'k';
  static const String setupTracker = 'l';

  // Initialize SharedPreferences asynchronously
  Future<void> init() async {
    _prefs = await _initPrefs();
  }

  // Private method to initialize SharedPreferences
  Future<SharedPreferences> _initPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Display Highlights
  bool getShowHighlight() {
    return _prefs.getBool(showHighlight) ?? true;
  }

  Future<void> setShowHighlight(bool value) async {
    await _prefs.setBool(showHighlight, value);
  }

  /// Display Sprints
  bool getShowSprints() {
    return _prefs.getBool(showSprints) ?? true;
  }

  Future<void> setShowSprints(bool value) async {
    await _prefs.setBool(showSprints, value);
  }

  /// Two Day Rule
  bool getTwoDayRule() {
    return _prefs.getBool(twoDayRule) ?? true;
  }

  Future<void> setTwoDayRule(bool value) async {
    await _prefs.setBool(twoDayRule, value);
  }

  /// File Numbering for stored files
  int getFileSequence() {
    return _prefs.getInt(fileSequence) ?? 0;
  }

  Future<void> setFileSequence(int value) async {
    await _prefs.setInt(fileSequence, value);
  }

  /// App Light(0) / Dark(1) / System(2) Theme
  int getAppMode() {
    return _prefs.getInt(appMode) ?? 2;
  }

  Future<void> setAppMode(int value) async {
    await _prefs.setInt(appMode, value);
  }

  /// Colorize Habit Text
  bool getColorizeHabitText() {
    return _prefs.getBool(colorizeHabitText) ?? true;
  }

  Future<void> setColorizeHabitText(bool value) async {
    await _prefs.setBool(colorizeHabitText, value);
  }

  /// Saturate Ritual Cards
  bool getSaturateCard() {
    return _prefs.getBool(saturateCards) ?? true;
  }

  Future<void> setSaturateCard(bool value) async {
    await _prefs.setBool(saturateCards, value);
  }

  /// Screen Timeout on Timer Screen
  bool getScreenTimeout() {
    return _prefs.getBool(screenTimeout) ?? true;
  }

  Future<void> setScreenTimeout(bool b) async {
    await _prefs.setBool(screenTimeout, b);
  }

  /// Screen Timeout on Timer Screen
  int getAppInit() {
    return _prefs.getInt(appInit) ?? 0;
  }

  Future<void> setAppInit(int b) async {
    await _prefs.setInt(appInit, b);
  }

  /// Break Time between Habits
  int getBreakTime() {
    return _prefs.getInt(breakTime) ?? 0;
  }

  Future<void> setBreakTime(int value) async {
    await _prefs.setInt(breakTime, value);
  }

  /// Setup Tracker - Refer to the Constants.dart file for the index of each setup
  bool getAppSetupTracker(int index) {
    // Get the index bit of the integer value using bitwise operator
    return ((_prefs.getInt(setupTracker) ?? 0) & (1 << index)) == (1 << index);
  }

  Future<void> setAppSetupTracker(int index) async {
    // Clear the index bit of the value using bitwise operator
    await _prefs.setInt(
        setupTracker, ((_prefs.getInt(setupTracker) ?? 0) | (1 << index)));
  }

  // Developer function - Clear AppSetupTracker
  Future<void> clearAppSetupTracker(int index) async {
    await _prefs.setInt(
        setupTracker, ((_prefs.getInt(setupTracker) ?? 0) & (0 << index)));
  }

  // Developer function - Clear Full Setup
  Future<void> clearAllAppSetupTracker() async {
    for (int x = 0; x < 14; x++) {
      await _prefs.setInt(
          setupTracker, ((_prefs.getInt(setupTracker) ?? 0) & (0 << x)));
    }
  }
}
