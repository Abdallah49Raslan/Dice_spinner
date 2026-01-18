
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastClaimCard extends StatelessWidget {
  final String title;
  final String text;

  const LastClaimCard({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}