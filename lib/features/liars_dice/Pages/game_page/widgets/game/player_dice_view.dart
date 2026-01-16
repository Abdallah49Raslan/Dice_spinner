import 'dart:math' as math;

import 'package:dice/core/constants/dice_constants.dart';
import 'package:dice/features/liars_dice/widgets/animated_dice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerDiceView extends StatelessWidget {
  final bool showDice;
  final List<int> dice;
  final int spinToken;
  final String hiddenText;

  const PlayerDiceView({
    super.key,
    required this.showDice,
    required this.dice,
    required this.spinToken,
    required this.hiddenText,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!showDice) {
          return Center(
            child: Text(
              hiddenText,
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
          );
        }

        final diceCount = dice.length;

        // ✅ فصلنا المسافات: أفقية للـ row ورأسية بين الصفوف
        final horizontalSpacing = 18.w;
        final verticalSpacing = 16.h;

        final availableWidth = constraints.maxWidth;

        // عدد النرد في الصف الواحد حسب الشكل المطلوب
        final maxInRow = (diceCount == 5)
            ? 3
            : (diceCount == 4 ? 2 : diceCount.clamp(1, 4));

        // ✅ استخدمنا horizontalSpacing في الحساب
        final maxPerDice =
            (availableWidth - (horizontalSpacing * (maxInRow - 1))) / maxInRow;

        final desired = availableWidth * DiceConstants.diceSizeRatio;

        final diceSize = math.min(math.min(maxPerDice, desired), 110.w);

        final rng = math.Random();

        Widget buildDie(int value) {
          return AnimatedDiceView(
            face: value,
            spinToken: spinToken,
            size: diceSize,
            showBackground: true,
            showLabel: false,
            tickFacePicker: () =>
                rng.nextInt(DiceConstants.facesCount) + DiceConstants.minFace,
          );
        }

        Widget buildRow(List<int> rowDice) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < rowDice.length; i++) ...[
                buildDie(rowDice[i]),
                if (i != rowDice.length - 1) SizedBox(width: horizontalSpacing),
              ],
            ],
          );
        }

        // ✅ 5 نرد: 3 فوق + 2 تحت
        if (diceCount == 5) {
          final row1 = dice.take(3).toList();
          final row2 = dice.skip(3).toList(); // 2

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRow(row1),
                SizedBox(height: verticalSpacing),
                buildRow(row2),
              ],
            ),
          );
        }

        // ✅ 4 نرد: 2 فوق + 2 تحت
        if (diceCount == 4) {
          final row1 = dice.take(2).toList();
          final row2 = dice.skip(2).toList();

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildRow(row1),
                SizedBox(height: verticalSpacing),
                buildRow(row2),
              ],
            ),
          );
        }

        // باقي الحالات: Wrap
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: horizontalSpacing,
            runSpacing: verticalSpacing,
            children: dice.map(buildDie).toList(),
          ),
        );
      },
    );
  }
}
