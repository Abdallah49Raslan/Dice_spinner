import 'package:dice/features/liars_dice/models/claim_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/localization_helper.dart';

class BettingHistoryPanel extends StatelessWidget {
  final List<ClaimHistoryItem> history;

  const BettingHistoryPanel({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.translate('betting_started'), // "بدأت المزايدة"
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),

        if (history.isEmpty)
          Text(
            t.translate('no_claims_yet'), // "مفيش مزايدات لسه"
            style: TextStyle(color: Colors.white54, fontSize: 14.sp),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t.translate('claims_history'), // "سجل المزايدات"
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                ...history.map((item) {
                  // مثال: "اللاعب 1 زايد على 2 من الوجه 5"
                  final line = t.translate(
                    'player_claim_line',
                    params: {
                      'player': item.playerName,
                      'qty': item.claim.quantity.toString(),
                      'face': item.claim.face.toString(),
                    },
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      line,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
