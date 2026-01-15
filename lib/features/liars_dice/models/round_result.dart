import 'claim_model.dart';
import 'player_model.dart';

class RoundResult {
  final ClaimModel claim;
  final bool claimIsTrue;
  final int winnerIndex;
  final int loserIndex;
  final List<PlayerModel> playersSnapshot;

  // ✅ جديد: ترتيب نهائي (من الأول للأخير)
  final List<PlayerModel>? finalStandings;

  const RoundResult({
    required this.claim,
    required this.claimIsTrue,
    required this.winnerIndex,
    required this.loserIndex,
    required this.playersSnapshot,
    this.finalStandings,
  });
}
