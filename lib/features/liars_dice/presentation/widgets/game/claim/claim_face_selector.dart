// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/localization_helper.dart';

class ClaimFaceSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final int minFace;
  final bool forbidOne;

  const ClaimFaceSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.minFace,
    required this.forbidOne,
  });

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    final itemSize = 44.w;
    final fontSize = itemSize * 0.32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.translate('face'),
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            final value = index + 1;

            final disabled = value < minFace || (forbidOne && value == 1);
            final isSelected = value == selected;

            return GestureDetector(
              onTap: disabled ? null : () => onChanged(value),
              child: Opacity(
                opacity: disabled ? 0.3 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: itemSize,
                  height: itemSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.1),
                    boxShadow: isSelected
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
                      fontSize: fontSize,
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
