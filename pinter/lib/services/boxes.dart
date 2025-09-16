import 'package:hive/hive.dart';

import 'package:ritual/model/ritual.dart';

// Services
import 'package:ritual/services/registry.dart';

class Boxes {
  static Box<Ritual> getBox() =>
    Hive.box<Ritual>(Registry.hiveFileName);

}