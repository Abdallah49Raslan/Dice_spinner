import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClaimFaceSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const ClaimFaceSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Face',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final value = index + 1;
            final selectedItem = value == selected;

            return GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedItem
                      ? Colors.white
                      : Colors.white.withOpacity(0.1),
                  boxShadow: selectedItem
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    color: selectedItem ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
