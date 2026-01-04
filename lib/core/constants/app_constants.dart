import 'package:flutter/material.dart';

abstract class AppConstants {
  // App
  static const String appName = 'Dice Spinner';

  // Animation (general)
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 400);
  static const Duration slowAnimation = Duration(milliseconds: 800);

  // Layout
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 16.0;

  // Shadow
  static const double defaultShadowBlur = 20.0;
  static const double defaultShadowOpacity = 0.15;

  // Colors (generic)
  static const Color lightTextColor = Colors.white;
}
