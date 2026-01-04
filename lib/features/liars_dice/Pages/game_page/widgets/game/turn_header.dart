import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TurnHeader extends StatelessWidget {
  final String text;

  const TurnHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
