import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/dice_constants.dart';
import '../../../core/theme/app_colors.dart';
import 'label_text.dart';
import 'pip_grid.dart';

class DiceFaceView extends StatelessWidget {
  final int face;

  const DiceFaceView({
    super.key,
    required this.face,
  });

  @override
  Widget build(BuildContext context) {
    final pips = DiceConstants.pipMap[face]!;

    return Container(
      width: 220.w,
      height: 220.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: DiceConstants
            .faceColors[(face - 1) % DiceConstants.facesCount],
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.diceBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.defaultShadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: LabelText(),
          ),
          Center(
            child: PipGrid(
              filledIndices: pips,
              pipColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
