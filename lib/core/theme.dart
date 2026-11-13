import 'package:flutter/material.dart';

abstract final class Palette {
  static const teal = Color(0xFF00867E);
  static const deepTeal = Color(0xFF006B65);
  static const ink = Color(0xFF102F3B);
  static const muted = Color(0xFF607078);
  static const background = Color(0xFFF5F9F8);
  static const mint = Color(0xFFE7F5F0);
  static const border = Color(0xFFDFE7E9);
  static const white = Colors.white;
  static const amber = Color(0xFF946000);
  static const amberLight = Color(0xFFFFEBC8);
  static const green = Color(0xFF21713E);
  static const greenLight = Color(0xFFE2F1E3);
}

abstract final class Space {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const radius = 18.0;
  static const controlRadius = 12.0;
  static const touch = 48.0;
  static const content = 780.0;
  static const mapHeight = 140.0;
  static const preview = 104.0;
  static const qr = 184.0;
}

abstract final class MotionTokens {
  static const quick = Duration(milliseconds: 200);
  static Duration duration(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : quick;
}

ThemeData buildTheme() {
  const family = 'Cairo';
  const base = TextStyle(fontFamily: family, height: 1.5, color: Palette.ink);
  final text = TextTheme(
    headlineLarge: base.copyWith(fontSize: 30, fontWeight: FontWeight.w800),
    headlineMedium: base.copyWith(fontSize: 25, fontWeight: FontWeight.w800),
    headlineSmall: base.copyWith(fontSize: 21, fontWeight: FontWeight.w800),
    titleLarge: base.copyWith(fontSize: 19, fontWeight: FontWeight.w700),
    titleMedium: base.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
    titleSmall: base.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    bodyLarge: base.copyWith(fontSize: 16),
    bodyMedium: base.copyWith(fontSize: 14),
    bodySmall: base.copyWith(fontSize: 12, color: Palette.muted),
    labelLarge: base.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
    labelMedium: base.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
    labelSmall: base.copyWith(fontSize: 11),
  );
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Space.controlRadius),
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: family,
    textTheme: text,
    colorScheme: ColorScheme.fromSeed(seedColor: Palette.teal).copyWith(
      primary: Palette.teal,
      onPrimary: Palette.white,
      surface: Palette.white,
      onSurface: Palette.ink,
    ),
    scaffoldBackgroundColor: Palette.background,
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: text.headlineSmall,
      iconTheme: const IconThemeData(color: Palette.ink),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(Space.touch, Space.touch),
        shape: shape,
        textStyle: text.labelLarge,
        padding: const EdgeInsets.all(Space.md),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(Space.touch, Space.touch),
        shape: shape,
        side: const BorderSide(color: Palette.teal),
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(Space.touch, Space.touch),
        textStyle: text.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.white,
      contentPadding: const EdgeInsets.all(Space.lg),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Space.controlRadius),
        borderSide: const BorderSide(color: Palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Space.controlRadius),
        borderSide: const BorderSide(color: Palette.border),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Palette.border),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Palette.white,
      indicatorColor: Palette.mint,
      labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
    ),
  );
}
