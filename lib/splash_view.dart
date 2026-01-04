import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'features/dice_spinner_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/icon/App_icon.png',
      backgroundColor: Colors.transparent,
      splashIconSize: 400.w,
      duration: 3000,
      nextScreen: DiceSpinnerPage(),
    );
  }
}