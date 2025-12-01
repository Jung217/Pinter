import 'package:flutter/material.dart';
import 'package:mypinter/config/app_settings.dart';
import 'package:mypinter/config/strings.dart';
import 'package:provider/provider.dart';

class L10n {
  static String of(BuildContext context, String key) {
    final language = Provider.of<AppSettings>(context, listen: false).language;
    return AppStrings.get(key, language);
  }
  
  static String withLang(String language, String key) {
    return AppStrings.get(key, language);
  }
}
