import 'package:dice/features/liars_dice/models/game_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helper/localization_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/widget/option_button.dart';
import '../models/liars_dice_setup_args.dart';

class LiarsDiceLevelScreen extends StatelessWidget {
  final LiarsDiceSetupArgs args;

  const LiarsDiceLevelScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final t = LocalizationHelper.of(context);
    final players = args.players;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.translate('choose_level'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),

              // Easy
              OptionButton(
                icon: Icons.looks_one,
                label: t.translate('easy'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/liars_dice_game',
                    arguments: {'players': players, 'level': GameLevel.easy},
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Medium
              OptionButton(
                icon: Icons.looks_3,
                label: t.translate('medium'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/liars_dice_game',
                    arguments: {'players': players, 'level': GameLevel.medium},
                  );
                },
              ),

              SizedBox(height: 16.h),

              // Hard
              OptionButton(
                icon: Icons.looks_5,
                label: t.translate('hard'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/liars_dice_game',
                    arguments: {'players': players, 'level': GameLevel.hard},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
