import 'package:flutter/material.dart';
import 'theme.dart';

abstract final class BrowseTokens {
  static const stackedWidth = 380.0;
  static const largeText = 1.5;
  static const cardRadius = 22.0;
  static const headerIcon = 32.0;
  static const sheetHeight = .85;
  static ChipAnimationStyle? chipMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
      ? ChipAnimationStyle(
          enableAnimation: AnimationStyle.noAnimation,
          selectAnimation: AnimationStyle.noAnimation,
          avatarDrawerAnimation: AnimationStyle.noAnimation,
          deleteDrawerAnimation: AnimationStyle.noAnimation,
        )
      : null;
  static ShapeBorder get shape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cardRadius),
    side: const BorderSide(color: Palette.border),
  );
}
