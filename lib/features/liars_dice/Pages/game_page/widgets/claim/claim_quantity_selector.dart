import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helper/localization_helper.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.translate('quantity'),
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),

        // ✅ مساحة ثابتة + سكرول عشان 30 رقم
        SizedBox(
          height: 150.h,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: maxQuantity,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // 6 أرقام في الصف (مناسبة للموبايل)
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
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

        // ✅ (اختياري لكن مفيد) سطر توضيح
        SizedBox(height: 8.h),
        Text(
          '${t.translate('quantity')}: $selected / $maxQuantity',
          style: TextStyle(color: Colors.white38, fontSize: 12.sp),
        ),
      ],
    );
  }
}
