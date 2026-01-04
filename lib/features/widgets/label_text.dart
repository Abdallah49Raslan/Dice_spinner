import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

class LabelText extends StatelessWidget {
  const LabelText({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Text(
        'Tap to roll',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
