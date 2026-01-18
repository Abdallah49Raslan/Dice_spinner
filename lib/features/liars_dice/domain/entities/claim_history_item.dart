import 'claim_model.dart';

class ClaimHistoryItem {
  final String playerName;
  final ClaimModel claim;

  const ClaimHistoryItem({
    required this.playerName,
    required this.claim,
  });
}
