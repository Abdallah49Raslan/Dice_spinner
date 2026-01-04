import 'package:dice/core/helper/localization_helper.dart';
import 'package:dice/core/theme/app_colors.dart';
import 'package:dice/features/home/widget/main_button.dart';
import 'package:dice/features/home/widget/option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showNormalGameOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocalizationHelper.of(context).translate('choose_dice_count'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20.h),

              // 🎲 One Dice
              OptionButton(
                icon: Icons.casino,
                label: LocalizationHelper.of(context).translate('one_dice'),

                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/one_dice');
                },
              ),

              SizedBox(height: 12.h),

              // 🎲🎲 Two Dice (later)
              OptionButton(
                icon: Icons.casino_outlined,
                label: LocalizationHelper.of(context).translate('two_dice'),

                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/two_dice');
                  // لاحقًا: صفحة 2 نرد
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🧊 Logo
              Image.asset(
                'assets/icon/App_icon.png', // صورة اللوجو
                width: 180.w,
              ),

              SizedBox(height: 60.h),

              // 🎲 Normal Game
              MainButton(
                icon: Icons.casino,
                label: LocalizationHelper.of(context).translate('normal_game'),

                onTap: () => _showNormalGameOptions(context),
              ),

              SizedBox(height: 20.h),

              // 🎮 Game Mode
              MainButton(
                icon: Icons.sports_esports,
                label: LocalizationHelper.of(context).translate('game_mode'),

                onTap: () {
                  // لاحقًا Game Modes
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
