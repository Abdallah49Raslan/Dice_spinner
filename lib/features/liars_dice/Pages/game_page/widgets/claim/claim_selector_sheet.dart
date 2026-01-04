import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/localization_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'claim_face_selector.dart';
import 'claim_quantity_selector.dart';

void showClaimSelector({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      final t = LocalizationHelper.of(context);

      int selectedQuantity = 1;
      int selectedFace = 1;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.translate('make_claim'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 24.h),

                ClaimQuantitySelector(
                  selected: selectedQuantity,
                  onChanged: (value) {
                    setState(() => selectedQuantity = value);
                  },
                ),

                SizedBox(height: 24.h),

                ClaimFaceSelector(
                  selected: selectedFace,
                  onChanged: (value) {
                    setState(() => selectedFace = value);
                  },
                ),

                SizedBox(height: 30.h),

                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Logic later
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      t.translate('confirm'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
