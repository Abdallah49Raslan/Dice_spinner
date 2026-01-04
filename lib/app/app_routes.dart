import 'package:dice/features/home/pages/home_screen.dart';
import 'package:dice/features/normal_dice/pages/dice_spinner_page.dart';
import 'package:dice/features/normal_dice/pages/two_dice_spinner_page.dart';
import 'package:dice/splash_view.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/one_dice':
        return MaterialPageRoute(builder: (_) => const DiceSpinnerPage());

      case '/two_dice':
        return MaterialPageRoute(builder: (_) => const TwoDiceSpinnerPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
