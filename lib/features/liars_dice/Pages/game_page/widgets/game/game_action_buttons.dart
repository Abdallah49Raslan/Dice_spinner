import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameActionButtons extends StatelessWidget {
  final String rollLabel;
  final String claimLabel;
  final String liarLabel;
  final VoidCallback onRoll;
  final VoidCallback onClaim;
  final VoidCallback onLiar;

  const GameActionButtons({
    super.key,
    required this.rollLabel,
    required this.claimLabel,
    required this.liarLabel,
    required this.onRoll,
    required this.onClaim,
    required this.onLiar,
  });

  @override
  Widget build(BuildContext context) {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              rollLabel,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        Row(
          children: [
            Expanded(
              child: _SecondaryButton(label: claimLabel, onTap: onClaim),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _SecondaryButton(label: liarLabel, onTap: onLiar),
            ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
