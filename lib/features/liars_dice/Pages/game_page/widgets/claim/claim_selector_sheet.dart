import 'package:dice/features/liars_dice/models/claim_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/localization_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'claim_face_selector.dart';
import 'claim_quantity_selector.dart';

void showClaimSelector({
  required BuildContext context,
  required void Function(int quantity, int face) onConfirm,
  required ClaimModel? currentBid,
  required bool isHardLevel,
  required int maxQuantity,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      final t = LocalizationHelper.of(context);

      int selectedQuantity =
          currentBid?.quantity ?? 1;
      int selectedFace =
          currentBid?.face ?? 1;

      return StatefulBuilder(
        builder: (context, setState) {
          final int minQuantity =
              currentBid?.quantity ?? 1;

          final int minFace =
              (currentBid != null &&
                      selectedQuantity ==
                          currentBid!.quantity)
                  ? currentBid!.face
                  : 1;

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
                  minQuantity: minQuantity,
                  maxQuantity: maxQuantity,
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value;
                      if (selectedFace < minFace) {
                        selectedFace = minFace;
                      }
                    });
                  },
                ),

                SizedBox(height: 24.h),

                ClaimFaceSelector(
                  selected: selectedFace,
                  minFace: minFace,
                  forbidOne: isHardLevel,
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
                      onConfirm(
                        selectedQuantity,
                        selectedFace,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16.r),
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
