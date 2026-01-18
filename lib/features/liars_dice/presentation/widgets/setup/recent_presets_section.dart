import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/theme/app_colors.dart';

class RecentPresetsSection extends StatelessWidget {
  final List<List<String>> presets;
  final ValueChanged<List<String>> onUse;
  final ValueChanged<int> onDelete;
  final VoidCallback onClearAll;

  const RecentPresetsSection({
    super.key,
    required this.presets,
    required this.onUse,
    required this.onDelete,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);

    if (presets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              t.translate('recent_players_lists'),
              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            TextButton(
              onPressed: onClearAll,
              child: Text(
                t.translate('clear_all'),
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: presets.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final players = presets[index];

            return Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.translate('players')} (${players.length})',
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          players.join(' • '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10.w),

                  _IconBtn(
                    icon: Icons.play_arrow_rounded,
                    tooltip: t.translate('use_list'),
                    onTap: () => onUse(players),
                  ),
                  SizedBox(width: 8.w),
                  _IconBtn(
                    icon: Icons.delete_outline,
                    tooltip: t.translate('delete_list'),
                    onTap: () => onDelete(index),
                    danger: true,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool danger;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: danger ? Colors.red.withOpacity(0.12) : Colors.white.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Icon(
            icon,
            color: danger ? Colors.redAccent : AppColors.white,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
