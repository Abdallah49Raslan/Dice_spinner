import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/localization_helper.dart';

class ClaimQuantitySelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final int minQuantity;
  final int maxQuantity;

  const ClaimQuantitySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.minQuantity,
    required this.maxQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    // ✅ Dynamic grid height based on how many rows we actually have
    const crossAxisCount = 6;
    final itemSize = 44.w; // approximate circle size
    final mainSpacing = 10.h;
    final crossSpacing = 10.w;

    final totalRows = (maxQuantity / crossAxisCount).ceil();
    final visibleRows = totalRows.clamp(1, 3); // show up to 3 rows, then scroll

    final gridHeight =
        (visibleRows * itemSize) + ((visibleRows - 1) * mainSpacing);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.translate('quantity'),
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),

        SizedBox(
          height: gridHeight,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: maxQuantity,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainSpacing,
              crossAxisSpacing: crossSpacing,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final value = index + 1;
              final disabled = value < minQuantity;
              final isSelected = value == selected;

              return GestureDetector(
                onTap: disabled ? null : () => onChanged(value),
                child: Opacity(
                  opacity: disabled ? 0.3 : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
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
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          '${t.translate('quantity')}: $selected / $maxQuantity',
          style: TextStyle(color: Colors.white38, fontSize: 12.sp),
        ),
      ],
    );
  }
}
