import 'package:flutter/widgets.dart';

/// Preserve the platform's scaling curve while applying the chosen multiplier.
class PreferenceTextScaler extends TextScaler {
  const PreferenceTextScaler(this.system, this.multiplier);
  final TextScaler system;
  final double multiplier;
  @override
  double scale(double fontSize) => system.scale(fontSize) * multiplier;
  @override
  double get textScaleFactor => scale(14) / 14;
}
