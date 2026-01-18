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

            final bool disabled = value < minFace || (forbidOne && value == 1);
            final bool isSelected = value == selected;

            return GestureDetector(
              onTap: disabled ? null : () => onChanged(value),
              child: Opacity(
                opacity: disabled ? 0.3 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? Colors.white : Colors.white.withOpacity(0.1),
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
