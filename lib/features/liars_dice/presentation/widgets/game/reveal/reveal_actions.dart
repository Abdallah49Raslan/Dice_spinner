import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealActions extends StatelessWidget {
  final String nextRoundLabel;
  final String endGameLabel;
  final VoidCallback onNextRound;
  final VoidCallback onEndGame;

  const RevealActions({
    super.key,
    required this.nextRoundLabel,
    required this.endGameLabel,
    required this.onNextRound,
    required this.onEndGame,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: onNextRound,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              nextRoundLabel,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: onEndGame,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              endGameLabel,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
