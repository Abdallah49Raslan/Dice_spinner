// liars_dice_state.dart
import '../models/claim_model.dart';
import '../models/game_phase.dart';
import '../models/player_model.dart';
import '../models/round_result.dart';

class LiarsDiceState {
  final List<PlayerModel> players;
  final int currentPlayerIndex;
  final GamePhase phase;

  final ClaimModel? currentClaim;
  final int? callerIndex;
  final RoundResult? lastRoundResult;

  final bool showDice;

  // ✅ rolling gate + animation trigger
  final List<bool> hasRolled;
  final int spinToken;

  // ✅ game over + standings
  final bool gameOver;
  final List<PlayerModel>? finalStandings;

  const LiarsDiceState({
    required this.players,
    required this.currentPlayerIndex,
    required this.phase,
    this.currentClaim,
    this.callerIndex,
    this.lastRoundResult,
    this.showDice = false,
    required this.hasRolled,
    this.spinToken = 0,
    this.gameOver = false,
    this.finalStandings,
  });

  static const _sentinel = Object();

  LiarsDiceState copyWith({
    List<PlayerModel>? players,
    int? currentPlayerIndex,
    GamePhase? phase,
    Object? currentClaim = _sentinel,
    Object? callerIndex = _sentinel,
    Object? lastRoundResult = _sentinel,
    bool? showDice,
    List<bool>? hasRolled,
    int? spinToken,
    bool? gameOver,
    Object? finalStandings = _sentinel,
  }) {
    return LiarsDiceState(
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      phase: phase ?? this.phase,
      currentClaim: identical(currentClaim, _sentinel)
          ? this.currentClaim
          : currentClaim as ClaimModel?,
      callerIndex: identical(callerIndex, _sentinel)
          ? this.callerIndex
          : callerIndex as int?,
      lastRoundResult: identical(lastRoundResult, _sentinel)
          ? this.lastRoundResult
          : lastRoundResult as RoundResult?,
      showDice: showDice ?? this.showDice,
      hasRolled: hasRolled ?? this.hasRolled,
      spinToken: spinToken ?? this.spinToken,
      gameOver: gameOver ?? this.gameOver,
      finalStandings: identical(finalStandings, _sentinel)
          ? this.finalStandings
          : finalStandings as List<PlayerModel>?,
    );
  }
}
