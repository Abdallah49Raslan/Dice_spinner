import 'package:dice/core/helper/localization_helper.dart';
import 'package:dice/features/liars_dice/models/claim_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealClaimSummary extends StatelessWidget {
  final ClaimModel claim;
  final List<List<int>> allDice;
  final bool onesAreWild;
  final bool claimIsTrue;

  const RevealClaimSummary({
    super.key,
    required this.claim,
    required this.allDice,
    required this.onesAreWild,
    required this.claimIsTrue,
  });

  ({int faceCount, int wildCount, int total}) _calculateCounts() {
    int faceCount = 0;
    int wildCount = 0;

    for (final diceList in allDice) {
      for (final d in diceList) {
        if (d == claim.face) {
          faceCount++;
        } else if (onesAreWild && d == 1 && claim.face != 1) {
          wildCount++;
        }
      }
    }

    return (
      faceCount: faceCount,
      wildCount: wildCount,
      total: faceCount + wildCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);
    final counts = _calculateCounts();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان
          Text(
            t.translate('claim'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 8.h),

          // claim نفسه
          Text(
            '${t.translate('quantity')}: ${claim.quantity}   •   ${t.translate('face')}: ${claim.face}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 14.h),

          // عدد الوش المطلوب
          Text(
            '${t.translate('face')} ${claim.face}: ${counts.faceCount}',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),

          // عدد الـ wild
          if (onesAreWild && claim.face != 1)
            Text(
              '${t.translate('wild_ones')}: ${counts.wildCount}',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),

          SizedBox(height: 6.h),

          // الإجمالي
          Text(
            '${t.translate('actual_count')}: ${counts.total}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 8.h),

          // النتيجة
          Text(
            claimIsTrue
                ? t.translate('claim_true')
                : t.translate('claim_false'),
            style: TextStyle(
              color: claimIsTrue ? Colors.greenAccent : Colors.redAccent,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
