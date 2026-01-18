import 'package:dice/features/liars_dice/presentation/widgets/setup/player_name_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerNamesList extends StatelessWidget {
  final String label;
  final List<String> names;
  final String Function(int index) hintBuilder;
  final void Function(int index, String value) onNameChanged;

  const PlayerNamesList({
    super.key,
    required this.label,
    required this.names,
    required this.hintBuilder,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
        SizedBox(height: 16.h),

        // ✅ داخل SingleChildScrollView: لازم shrinkWrap + no scroll
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: names.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return PlayerNameField(
              // مهم عشان TextFormField يعيد initValue صح لما العدد يتغير
              key: ValueKey('player_name_$index${names.length}'),
              value: names[index],
              hint: hintBuilder(index),
              onChanged: (v) => onNameChanged(index, v),
            );
          },
        ),
      ],
    );
  }
}
