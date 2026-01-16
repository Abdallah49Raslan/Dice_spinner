// ignore_for_file: deprecated_member_use

import 'package:dice/features/liars_dice/Pages/game_page/widgets/claim/last_claim_helper.dart';
import 'package:dice/features/liars_dice/Pages/game_page/widgets/claim/pill_label.dart';
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
  required bool onesAreWild,
  required int maxQuantity,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.scaffoldBackground,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      final t = LocalizationHelper.of(context);

      int selectedQuantity = currentBid?.quantity ?? 1;
      int selectedFace = currentBid?.face ?? 1;

      return StatefulBuilder(
        builder: (context, setState) {
          final minQuantity = currentBid?.quantity ?? 1;

          final minFace =
              (currentBid != null && selectedQuantity == currentBid.quantity)
              ? currentBid.face
              : 1;

          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Handle
                  Container(
                    width: 44.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    t.translate('make_claim'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ✅ محتوى قابل للسكرول (بدون ما نزود SizedBox كتير)
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (currentBid != null) ...[
                            LastClaimCard(
                              title: t.translate('last_claim'),
                              text:
                                  '${t.translate('quantity')}: ${currentBid.quantity}  •  ${t.translate('face')}: ${currentBid.face}',
                            ),
                            SizedBox(height: 10.h),
                          ],

                          if (onesAreWild) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: PillLabel(
                                text: '1 = ${t.translate('wild')}',
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],

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

                          SizedBox(height: 16.h),

                          ClaimFaceSelector(
                            selected: selectedFace,
                            minFace: minFace,
                            forbidOne: onesAreWild,
                            onChanged: (value) =>
                                setState(() => selectedFace = value),
                          ),

                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ✅ زر ثابت تحت
                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm(selectedQuantity, selectedFace);
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
            ),
          );
        },
      );
    },
  );
}
