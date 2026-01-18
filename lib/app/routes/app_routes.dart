import 'package:dice/features/liars_dice/presentation/models/liars_dice_game_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/liars_dice/domain/entities/game_config.dart';
import '../../features/liars_dice/presentation/cubit/game/liars_dice_cubit.dart';
import '../../features/liars_dice/presentation/models/liars_dice_setup_args.dart';
import '../../features/liars_dice/presentation/pages/game/liars_dice_game_page.dart';
import '../../features/liars_dice/presentation/pages/game/liars_dice_reveal_page.dart';
import '../../features/liars_dice/presentation/pages/game/liars_dice_winner_page.dart';
import '../../features/liars_dice/presentation/pages/level/liars_dice_level_screen.dart';
import '../../features/liars_dice/presentation/pages/setup/liars_dice_setup_page.dart';
import '../../features/normal_dice/presentation/pages/dice_spinner_page.dart';
import '../../features/normal_dice/presentation/pages/two_dice_spinner_page.dart';
import '../../splash_view.dart';
import '../di/service_locator.dart';

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
        // arguments: {'players': players, 'level': GameLevel.x}
        final args = settings.arguments as LiarsDiceGameArgs;
        final players = args.players;
        final level = args.level;

        final config = GameConfig.fromLevel(level);

        return MaterialPageRoute(
          builder: (_) => BlocProvider<LiarsDiceCubit>(
            // ✅ DI (no direct new)
            create: (_) => sl<LiarsDiceCubit>(
              param1: LiarsDiceCubitParams(
                playerNames: players,
                config: config,
              ),
            ),
            child: const LiarsDiceGamePage(),
          ),
        );

      case '/liars_dice_reveal':
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
