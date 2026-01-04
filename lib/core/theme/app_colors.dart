import 'package:flutter/material.dart';

abstract class AppColors {
  // ===== Base Colors =====
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ===== Text Colors =====
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFE5E7EB); // light gray
  static const Color textMuted = Color(0xFF9CA3AF); // muted gray

  // ===== Backgrounds =====
  static const Color scaffoldBackground = Color(0xFF0F172A); // dark blue
  static const Color overlayBackground = Color(0x14000000); // black with opacity

  // ===== Dice Colors =====
  static const Color diceBorder = Color(0x40FFFFFF); // white 25%
  static const Color diceShadow = Color(0x26000000); // black shadow
  static const Color diceBackgroundOverlay = Color(0x14000000);

  // ===== Status / Feedback =====
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // ===== Shadows =====
  // ignore: deprecated_member_use
  static Color defaultShadow = Colors.black.withOpacity(0.15);
}
