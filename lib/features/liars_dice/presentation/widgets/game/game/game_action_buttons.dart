import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameActionButtons extends StatelessWidget {
  final String rollLabel;
  final String claimLabel;
  final String liarLabel;

  final VoidCallback? onRoll;
  final VoidCallback? onClaim;
  final VoidCallback? onLiar;

  // ✅ جديد
  final Color? claimColor; // لون زر Claim وقت المزايدة
  final Color? liarColor;  // لون زر Liar وقت المزايدة

  const GameActionButtons({
    super.key,
    required this.rollLabel,
    required this.claimLabel,
    required this.liarLabel,
    this.onRoll,
    this.onClaim,
    this.onLiar,
    this.claimColor,
    this.liarColor,
  });

  @override
  Widget build(BuildContext context) {
    Color borderFor(VoidCallback? onPressed, Color? c) {
      if (onPressed == null) return Colors.white12;
      return (c ?? Colors.white24);
    }

    Color textFor(VoidCallback? onPressed, Color? c) {
      if (onPressed == null) return Colors.white38;
      // لو فيه لون مخصص نخلي النص أبيض
      return c != null ? Colors.white : Colors.white;
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: onRoll,
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
                  onPressed: onClaim,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: borderFor(onClaim, claimColor),
                      width: claimColor != null && onClaim != null ? 1.6 : 1,
                    ),
                    backgroundColor: (claimColor != null && onClaim != null)
                        ? claimColor!.withOpacity(0.18)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    claimLabel,
                    style: TextStyle(
                      color: textFor(onClaim, claimColor),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
                  onPressed: onLiar,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: borderFor(onLiar, liarColor),
                      width: liarColor != null && onLiar != null ? 1.6 : 1,
                    ),
                    backgroundColor: (liarColor != null && onLiar != null)
                        ? liarColor!.withOpacity(0.18)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    liarLabel,
                    style: TextStyle(
                      color: textFor(onLiar, liarColor),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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
