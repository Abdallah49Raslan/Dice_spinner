import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../players_count_chip.dart';

class PlayersCountPicker extends StatelessWidget {
  final String label;
  final int selectedCount;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const PlayersCountPicker({
    super.key,
    required this.label,
    required this.selectedCount,
    required this.onChanged,
    this.min = 2,
    this.max = 6,
  });

  @override
  Widget build(BuildContext context) {
    final total = (max - min) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          children: List.generate(total, (index) {
            final value = min + index;
            return PlayersCountChip(
              value: value,
              selected: selectedCount == value,
              onTap: () => onChanged(value),
            );
          }),
        ),
      ],
    );
  }
}
