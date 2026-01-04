import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/dice_constants.dart';
import '../../../core/theme/app_colors.dart';
import 'label_text.dart';
import 'pip_grid.dart';

class DiceFaceView extends StatelessWidget {
  final int face;

  const DiceFaceView({super.key, required this.face});

  @override
  Widget build(BuildContext context) {
    final pips = DiceConstants.pipMap[face]!;

    return Container(
      color: DiceConstants.faceColors[(face - 1) % DiceConstants.facesCount],
      child: SafeArea(
        child: Stack(
          children: [
            const Positioned(top: 16, left: 0, right: 0, child: LabelText()),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size =
                      constraints.biggest.shortestSide *
                      DiceConstants.diceSizeRatio;

                  return Container(
                    width: size,
                    height: size,
                    padding: EdgeInsets.all(
                      size * DiceConstants.dicePaddingRatio,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.diceBackgroundOverlay,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: AppColors.diceBorder, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.defaultShadow,
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: PipGrid(
                      filledIndices: pips,
                      pipColor: AppColors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
