// ignore_for_file: deprecated_member_use

import '../../../../../../core/localization/localization_helper.dart';
import '../../../../domain/entities/claim_model.dart';
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

    final requiredQty = claim.quantity;
    final actual = counts.total;

    final double progress = requiredQty <= 0
        ? 0
        : (actual / requiredQty).clamp(0.0, 1.0);

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
          Text(
            t.translate('claim'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),

          Text(
            '${t.translate('quantity')}: $requiredQty   •   ${t.translate('face')}: ${claim.face}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 14.h),

          // تفاصيل العد قبل الـ actual
          Text(
            '${t.translate('face')} ${claim.face}: ${counts.faceCount}',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          if (onesAreWild && claim.face != 1)
            Text(
              '${t.translate('wild_ones')}: ${counts.wildCount}',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),

          SizedBox(height: 10.h),

          // ✅ Progress bar + أرقام
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${t.translate('actual_count')}: $actual',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$actual / $requiredQty',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10.h,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(
                claimIsTrue ? Colors.greenAccent : Colors.redAccent,
              ),
            ),
          ),

          SizedBox(height: 10.h),

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
