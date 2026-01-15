import 'package:dice/features/liars_dice/Pages/game_page/screens/liars_dice_reveal_page.dart';
import 'package:dice/features/liars_dice/Pages/game_page/screens/liars_dice_winner_page.dart';
import 'package:dice/features/liars_dice/cubit/liars_dice_cubit.dart';
import 'package:dice/features/liars_dice/models/game_config.dart';
import 'package:dice/features/liars_dice/models/liars_dice_setup_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/home/pages/home_screen.dart';
import '../features/liars_dice/Pages/game_page/screens/liars_dice_game_page.dart';
import '../features/liars_dice/Pages/liars_dice_level_screen.dart';
import '../features/liars_dice/Pages/setup_page/screens/liars_dice_setup_page.dart';
import '../features/normal_dice/pages/dice_spinner_page.dart';
import '../features/normal_dice/pages/two_dice_spinner_page.dart';
import '../splash_view.dart';

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

      case '/liars_dice_setup':
        return MaterialPageRoute(builder: (_) => const LiarsDiceSetupPage());

      case '/liars_dice_levels':
        final args = settings.arguments as LiarsDiceSetupArgs;
        return MaterialPageRoute(
          builder: (_) => LiarsDiceLevelScreen(args: args),
        );

      case '/liars_dice_game':
        final args = settings.arguments as Map<String, dynamic>;
        final List<String> players = List<String>.from(args['players']);
        final GameLevel level = args['level'] as GameLevel;

        return MaterialPageRoute(
          builder: (_) => BlocProvider<LiarsDiceCubit>(
            create: (_) => LiarsDiceCubit(
              playerNames: players,
              config: GameConfig.fromLevel(level),
            ),
            child: LiarsDiceGamePage(),
          ),
        );

      case '/liars_dice_reveal':
        // IMPORTANT: cubit is passed as arguments from the game page
        final cubit = settings.arguments as LiarsDiceCubit;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const LiarsDiceRevealPage(),
          ),
        );
      case '/liars_dice_winner':
        final cubit = settings.arguments as LiarsDiceCubit;

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const LiarsDiceWinnerPage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
