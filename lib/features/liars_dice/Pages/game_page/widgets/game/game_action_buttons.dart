import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameActionButtons extends StatelessWidget {
  final String rollLabel;
  final String claimLabel;
  final String liarLabel;

  final VoidCallback? onRoll;
  final VoidCallback? onClaim;
  final VoidCallback? onLiar;

  const GameActionButtons({
    super.key,
    required this.rollLabel,
    required this.claimLabel,
    required this.liarLabel,
    this.onRoll,
    this.onClaim,
    this.onLiar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: onRoll, // ✅ nullable
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              disabledBackgroundColor: Colors.white.withOpacity(0.35),
              disabledForegroundColor: Colors.black.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              rollLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: OutlinedButton(
                  onPressed: onClaim, // ✅ nullable
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: onClaim == null ? Colors.white12 : Colors.white24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    claimLabel,
                    style: TextStyle(
                      color: onClaim == null ? Colors.white38 : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: OutlinedButton(
                  onPressed: onLiar, // ✅ nullable
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: onLiar == null ? Colors.white12 : Colors.white24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    liarLabel,
                    style: TextStyle(
                      color: onLiar == null ? Colors.white38 : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
