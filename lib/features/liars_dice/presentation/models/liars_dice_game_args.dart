import '../../domain/entities/game_config.dart';

class LiarsDiceGameArgs {
  final List<String> players;
  final GameLevel level;

  const LiarsDiceGameArgs({
    required this.players,
    required this.level,
  });
}
