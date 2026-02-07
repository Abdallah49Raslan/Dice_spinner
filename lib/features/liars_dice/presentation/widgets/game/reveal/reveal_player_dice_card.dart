// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealPlayerDiceCard extends StatelessWidget {
  final String playerName;
  final List<int> diceValues;
  final bool isWinner;
  final bool isLoser;

  final int claimFace;
  final bool onesAreWild;

  const RevealPlayerDiceCard({
    super.key,
    required this.playerName,
    required this.diceValues,
    this.isWinner = false,
    this.isLoser = false,
    required this.claimFace,
    required this.onesAreWild,
  });

  bool _isMatched(int value) {
    if (value == claimFace) return true;
    if (onesAreWild && value == 1 && claimFace != 1) return true;
    return false;
  }

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

          // 🎲 Dice Row (with highlight)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: diceValues.map((value) {
              final matched = _isMatched(value);
              final isWildOne = onesAreWild && value == 1 && claimFace != 1;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: matched
                          ? Colors.white
                          : Colors.white.withOpacity(0.12),
                      boxShadow: matched
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                      border: matched
                          ? Border.all(
                              color: isWildOne
                                  ? Colors.amberAccent
                                  : Colors.white,
                              width: isWildOne ? 2 : 1,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: matched ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

                  // ✅ علامة W لو 1 اتحسب Wild
                  if (matched && isWildOne)
                    Positioned(
                      right: -4.w,
                      bottom: -4.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'W',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
