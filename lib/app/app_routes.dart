import 'package:dice/features/liars_dice/Pages/game_page/screens/liars_dice_reveal_page.dart';

import '../features/home/pages/home_screen.dart';
import '../features/liars_dice/Pages/game_page/screens/liars_dice_game_page.dart';
import '../features/liars_dice/Pages/liars_dice_level_screen.dart';
import '../features/liars_dice/Pages/setup_page/screens/liars_dice_setup_page.dart';
import '../features/normal_dice/pages/dice_spinner_page.dart';
import '../features/normal_dice/pages/two_dice_spinner_page.dart';
import '../splash_view.dart';
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

      case '/liars_dice_levels':
        return MaterialPageRoute(builder: (_) => const LiarsDiceLevelScreen());

      case '/liars_dice_setup':
        return MaterialPageRoute(builder: (_) => const LiarsDiceSetupPage());

      case '/liars_dice_game':
        return MaterialPageRoute(builder: (_) => const LiarsDiceGamePage());

      case '/liars_dice_reveal':
        return MaterialPageRoute(builder: (_) => const LiarsDiceRevealPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
