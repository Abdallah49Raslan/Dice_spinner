import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayersCountChip extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const PlayersCountChip({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          value.toString(),
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
