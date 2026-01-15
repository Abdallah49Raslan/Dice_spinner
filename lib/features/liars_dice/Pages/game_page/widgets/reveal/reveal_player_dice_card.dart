import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealPlayerDiceCard extends StatelessWidget {
  final String playerName;
  final List<int> diceValues;
  final bool isWinner;
  final bool isLoser;

  const RevealPlayerDiceCard({
    super.key,
    required this.playerName,
    required this.diceValues,
    this.isWinner = false,
    this.isLoser = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isWinner
        ? Colors.greenAccent
        : isLoser
        ? Colors.redAccent
        : Colors.white24;

    final Color backgroundColor = isWinner
        ? Colors.green.withOpacity(0.15)
        : isLoser
        ? Colors.red.withOpacity(0.15)
        : Colors.white.withOpacity(0.08);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: isWinner || isLoser ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 Player Name
          Text(
            playerName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: isWinner ? FontWeight.bold : FontWeight.w500,
            ),
          ),

          SizedBox(height: 12.h),

          // 🎲 Dice Row
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: diceValues.map((value) {
              return Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
