import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dice/core/theme/app_colors.dart';
import 'package:dice/features/home/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/icon/App_icon.png',
      backgroundColor: AppColors.scaffoldBackground,
      splashIconSize: 400.w,
      duration: 3000,
      nextScreen: HomeScreen(),
    );
  }
}
