import 'package:dice/features/liars_dice/domain/actions/game_action.dart';

import '../entities/claim_model.dart';

class ClaimAction extends GameAction {
  final ClaimModel claim;

  const ClaimAction({
    required this.claim,
  });
}