import 'package:hive/hive.dart';

part 'ritual.g.dart';

@HiveType(typeId: 0)
class Ritual extends HiveObject{
  // Percentage of habit complete
  @HiveField(0)
  double complete = 0;

  // Checked on Date
  @HiveField(9)
  DateTime? checkedOn;

  // Path to the habit
  @HiveField(1)
  String url = "";

  // Background image of Ritual only
  @HiveField(2)
  String? background;

  // Reminder Time for Ritual
  @HiveField(3)
  Map time = {"hour": 0, "minute": 0};

  // Type of Habit
  @HiveField(4)
  String? type;

  // Expiry for Sprints and Highlights
  @HiveField(5)
  DateTime? expiry;

  // Habit Position in the Ritual screen
  @HiveField(6)
  int? position;

  // Habit priority
  @HiveField(7)
  int priority = 4;

  // Creation Date for 1% habits
  @HiveField(8)
  DateTime? createdOn;

  // Habit Duration
  @HiveField(10)
  double? duration;

  // Initial Value for 1% Habits
  @HiveField(11)
  int? initValue;

  // Stack time for stacked Habits
  @HiveField(12)
  bool stackTime = false;

  // Stack value type
  @HiveField(13)
  bool integralStackValue = true;
}

