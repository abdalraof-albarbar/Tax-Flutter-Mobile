import 'package:flutter/material.dart';

extension TranslatedContext on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
  String tr(String arabic, String english) => isArabic ? arabic : english;
}
