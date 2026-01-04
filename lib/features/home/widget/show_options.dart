import '../../../core/helper/localization_helper.dart';
import '../../../core/theme/app_colors.dart';
import 'option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showOptions({
  required BuildContext context,
  required String titleKey,
  required List<OptionItem> options,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      final t = LocalizationHelper.of(context);

      return Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.translate(titleKey),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),

            ...options.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: OptionButton(
                  icon: item.icon,
                  label: t.translate(item.labelKey),
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class OptionItem {
  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;

  OptionItem({
    required this.icon,
    required this.labelKey,
    required this.onTap,
  });
}

