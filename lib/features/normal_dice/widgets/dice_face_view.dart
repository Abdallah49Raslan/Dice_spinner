import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/dice_constants.dart';
import '../../../../core/theme/app_colors.dart';
import 'label_text.dart';
import 'pip_grid.dart';

class DiceFaceView extends StatelessWidget {
  final int face;
  final Animation<double>? rotation;
  final bool showBackground;
  final bool showLabel;
  final double? size;

  /// الكونستركتور العادي (زي ما كان)
  const DiceFaceView({
    super.key,
    required this.face,
    this.rotation,
    this.showBackground = true,
    this.showLabel = true,
    this.size,
  });

  /// 👈 الكونستركتور الجديد (النرد الخام فقط)
  const DiceFaceView.pure({
    super.key,
    required this.face,
    this.rotation,
    this.size,
  })  : showBackground = false,
        showLabel = false;

  @override
  Widget build(BuildContext context) {
    // حماية من أي قيمة غلط
    final safeFace = face.clamp(1, 6);
    final pips = DiceConstants.pipMap[safeFace]!;

    final dice = LayoutBuilder(
      builder: (context, constraints) {
        final calculatedSize =
            size ??
            constraints.biggest.shortestSide * DiceConstants.diceSizeRatio;

        return Container(
          width: calculatedSize,
          height: calculatedSize,
          padding: EdgeInsets.all(
            calculatedSize * DiceConstants.dicePaddingRatio,
          ),
          decoration: BoxDecoration(
            color: AppColors.diceBackgroundOverlay,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.diceBorder, width: 2.w),
            boxShadow: showBackground
                ? [
                    BoxShadow(
                      color: AppColors.defaultShadow,
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: PipGrid(filledIndices: pips, pipColor: AppColors.white),
        );
      },
    );

    final rotatedDice = AnimatedBuilder(
      animation: rotation ?? const AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        return Transform.rotate(
          angle: (rotation?.value ?? 0) * 6 * pi,
          child: child,
        );
      },
      child: dice,
    );

    // ✅ الوضع البسيط (نرد فقط)
    if (!showBackground && !showLabel) {
      return rotatedDice;
    }

    // ✅ الوضع الكامل (زي DiceSpinner)
    return Container(
      color: showBackground
          ? DiceConstants.faceColors[(safeFace - 1) % DiceConstants.facesCount]
          : Colors.transparent,
      child: Stack(
        children: [
          if (showLabel)
            const Positioned(top: 16, left: 0, right: 0, child: LabelText()),
          Center(child: rotatedDice),
        ],
      ),
    );
  }
}
