import 'package:dice/features/liars_dice/domain/actions/game_action.dart';

class RollAction extends GameAction {
  final int playerIndex;
  final List<int> dice;

  const RollAction({
    required this.playerIndex,
    required this.dice,
  });
}