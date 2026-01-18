import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const RevealHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
