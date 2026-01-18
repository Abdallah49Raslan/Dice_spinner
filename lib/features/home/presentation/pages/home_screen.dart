import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/localization/localization_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/main_button.dart';
import '../widgets/show_options.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                onTap: () {
                  showOptions(
                    context: context,
                    titleKey: 'choose_dice_count',
                    options: [
                      OptionItem(
                        icon: Icons.casino,
                        labelKey: 'one_dice',
                        onTap: () {
                          Navigator.pushNamed(context, '/one_dice');
                        },
                      ),
                      OptionItem(
                        icon: Icons.casino_outlined,
                        labelKey: 'two_dice',
                        onTap: () {
                          Navigator.pushNamed(context, '/two_dice');
                        },
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 20.h),

              // 🎮 Game Mode
              MainButton(
                icon: Icons.sports_esports,
                label: LocalizationHelper.of(context).translate('game_mode'),
                onTap: () {
                  showOptions(
                    context: context,
                    titleKey: 'choose_game',
                    options: [
                      OptionItem(
                        icon: Icons.extension,
                        labelKey: 'liars_dice',
                        onTap: () {
                          Navigator.pushNamed(context, '/liars_dice_setup');
                        },
                      ),
                    ],
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
