import 'package:flutter/material.dart';
import 'theme.dart';

abstract final class ComponentTokens {
  static const cardRadius = 24.0;
  static const ringSize = 88.0;
  static const ringStroke = 6.0;
  static const summaryRowWidth = 240.0;
  static const shortcutWide = 680.0;
  static const shortcutStacked = 280.0;
  static const shortcutHeight = 104.0;
  static const shortcutIcon = 32.0;
  static const enlargedText = 1.6;
  static const compactFeedbackWidth = 360.0;
  static const compactFeedbackScale = 1.5;
  static const feedbackBreakpoint = 600.0;
  static const feedbackWidth = 560.0;
  static const containerDuration = Duration(milliseconds: 420);
  static Color get onTealMuted => Palette.white.withValues(alpha: .85);
  static Color get onTealTrack => Palette.white.withValues(alpha: .22);
  static BoxDecoration get overview => BoxDecoration(
    color: Palette.deepTeal,
    borderRadius: BorderRadius.circular(cardRadius),
  );
  static BoxDecoration get stat => BoxDecoration(
    color: Palette.white.withValues(alpha: .12),
    borderRadius: BorderRadius.circular(Space.controlRadius),
    border: Border.all(color: Palette.white.withValues(alpha: .2)),
  );
  static ShapeBorder get cardShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(cardRadius),
    side: const BorderSide(color: Palette.border),
  );
  static BoxDecoration get navigation => BoxDecoration(
    color: Palette.white,
    borderRadius: BorderRadius.circular(cardRadius),
    border: Border.all(color: Palette.border),
    boxShadow: [
      BoxShadow(
        color: Palette.ink.withValues(alpha: .05),
        blurRadius: Space.xl,
        offset: const Offset(0, Space.sm),
      ),
    ],
  );
}
