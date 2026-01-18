import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DicePlaceholder extends StatelessWidget {
  final bool hidden;
  final String hiddenText;
  final String shownText;

  const DicePlaceholder({
    super.key,
    required this.hidden,
    required this.hiddenText,
    required this.shownText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 200.w,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white24),
      ),
      alignment: Alignment.center,
      child: Text(
        hidden ? hiddenText : shownText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
