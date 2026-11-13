import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

abstract final class ProfileTokens {
  static const nameColumnMinWidth = 160.0;
  static const avatarSize = 104.0;
  static const cameraBadge = 32.0;
  static const cameraIcon = 18.0;
  static const identityRadius = 24.0;
  static const accentRail = 6.0;
  static const focusWidth = 2.0;
  static const focusSpread = 3.0;
  static const controlHeight = 56.0;
  static const wideLayout = 600.0;
  static const copyWidth = 560.0;
  static const pressScale = .97;
  static const enter = Duration(milliseconds: 320);
  static const exit = Duration(milliseconds: 220);
  static const curve = Cubic(.2, 0, 0, 1);

  static Duration duration(BuildContext context) =>
      MotionTokens.duration(context);
  static double toolbarHeight(
    BuildContext context,
    String title,
    double width,
  ) {
    final painter =
        TextPainter(
          text: TextSpan(
            text: title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          textDirection: Directionality.of(context),
          locale: Localizations.localeOf(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(
          maxWidth: math.max(
            Space.touch,
            width - Space.touch - Space.sm - 2 * Space.lg,
          ),
        );
    final result = math.max(Space.touch + Space.lg, painter.height + Space.md);
    painter.dispose();
    return result;
  }

  static AnimationStyle animationStyle(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
      ? AnimationStyle.noAnimation
      : const AnimationStyle(duration: enter, reverseDuration: exit);
  static BoxDecoration get identity => BoxDecoration(
    color: Palette.white,
    borderRadius: BorderRadius.circular(identityRadius),
    border: Border.all(color: Palette.border),
    boxShadow: [
      BoxShadow(
        color: Palette.ink.withValues(alpha: .06),
        blurRadius: Space.xl,
        offset: const Offset(0, Space.sm),
      ),
    ],
  );
  static BoxDecoration get panel => BoxDecoration(
    color: Palette.white,
    borderRadius: BorderRadius.circular(Space.radius),
    border: Border.all(color: Palette.border),
  );
  static BoxDecoration get track => BoxDecoration(
    color: Palette.mint,
    borderRadius: BorderRadius.circular(Space.controlRadius + Space.xs),
  );
  static BoxDecoration get selection => BoxDecoration(
    color: Palette.white,
    border: Border.all(color: Palette.deepTeal),
    borderRadius: BorderRadius.circular(Space.controlRadius),
  );
  static Color get clear => Palette.white.withValues(alpha: 0);
  static Color get splash => Palette.teal.withValues(alpha: .12);
  static ThemeData theme(ThemeData base) => base.copyWith(
    colorScheme: base.colorScheme.copyWith(primary: Palette.deepTeal),
  );
}
