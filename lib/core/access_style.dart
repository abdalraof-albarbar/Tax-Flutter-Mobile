import 'package:flutter/material.dart';
import 'theme.dart';
import 'app_assets.dart';

abstract final class AccessTokens {
  static const wide = 900.0, content = 1120.0, formWidth = 440.0;
  static const imageHeight = 180.0, welcomeImageHeight = 280.0;
  static const wideImageHeight = 390.0, panelRadius = 28.0;
  static const buttonHeight = 56.0;
  static const wideTextScaleLimit = 1.6;
  static const welcomeImage = AppAssets.fieldWelcome;
  static const folioImage = AppAssets.accessFolio;
  static ThemeData theme(ThemeData base) => base.copyWith(
    colorScheme: base.colorScheme.copyWith(primary: Palette.deepTeal),
  );
  static BoxDecoration get panel => BoxDecoration(
    color: Palette.white,
    borderRadius: BorderRadius.circular(panelRadius),
    border: Border.all(color: Palette.border),
  );
}
