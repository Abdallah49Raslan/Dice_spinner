import 'package:flutter/material.dart';

abstract class DiceConstants {
  // Dice basics
  static const int minFace = 1;
  static const int maxFace = 6;
  static const int facesCount = 6;

  // Dice spin behavior
  static const int minExtraSteps = 12;
  static const int maxExtraSteps = 30;

  static const Duration baseSpinDuration = Duration(milliseconds: 900);
  static const int extraStepDurationMs = 35;

  // Dice animation
  static const Curve spinCurve = Curves.easeOutCubic;

  // Dice UI
  static const double diceSizeRatio = 0.55;
  static const double dicePaddingRatio = 0.12;
  static const double diceBorderOpacity = 0.25;
  static const double diceBackgroundOpacity = 0.08;

  // Dice faces colors
  static const List<Color> faceColors = <Color>[
    Color(0xFF0EA5E9),
    Color(0xFF22C55E),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF14B8A6),
  ];

  // Dice pip positions (3x3 grid)
  static const Map<int, List<int>> pipMap = {
    1: [4],
    2: [0, 8],
    3: [0, 4, 8],
    4: [0, 2, 6, 8],
    5: [0, 2, 4, 6, 8],
    6: [0, 2, 3, 5, 6, 8],
  };

  // Dice count
  static const int singleDice = 1;
  static const int doubleDice = 2;
}
