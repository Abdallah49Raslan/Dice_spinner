import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const OptionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  bool get _isDisabled => onTap == null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDisabled ? 0.4 : 1.0,
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: OutlinedButton.icon(
          onPressed: _isDisabled ? null : onTap,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          label: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
