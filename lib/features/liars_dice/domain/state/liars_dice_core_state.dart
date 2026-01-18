import '../entities/claim_history_item.dart';
import '../entities/claim_model.dart';
import '../entities/game_phase.dart';
import '../entities/player_model.dart';
import '../entities/round_result.dart';

class LiarsDiceCoreState {
  final List<PlayerModel> players;
  final int currentPlayerIndex;
  final GamePhase phase;

  final ClaimModel? currentClaim;
  final int? callerIndex;
  final RoundResult? lastRoundResult;

  final List<bool> hasRolled;
  final bool gameOver;
  final List<PlayerModel>? finalStandings;

  final int bettingStarterIndex;
  final List<ClaimHistoryItem> claimHistory;
  final List<PlayerModel> eliminated;


  const LiarsDiceCoreState({
    required this.players,
    required this.currentPlayerIndex,
    required this.phase,
    this.currentClaim,
    this.callerIndex,
    this.lastRoundResult,
    required this.hasRolled,
    this.gameOver = false,
    this.finalStandings,
    this.bettingStarterIndex = 0,
    required this.claimHistory,
    this.eliminated = const [],
  });

  static const _sentinel = Object();

  LiarsDiceCoreState copyWith({
    List<PlayerModel>? players,
    int? currentPlayerIndex,
    GamePhase? phase,
    Object? currentClaim = _sentinel,
    Object? callerIndex = _sentinel,
    Object? lastRoundResult = _sentinel,
    List<bool>? hasRolled,
    bool? gameOver,
    Object? finalStandings = _sentinel,
    int? bettingStarterIndex,
    List<ClaimHistoryItem>? claimHistory,
    List<PlayerModel>? eliminated,
  }) {
    return LiarsDiceCoreState(
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
      hasRolled: hasRolled ?? this.hasRolled,
      gameOver: gameOver ?? this.gameOver,
      finalStandings: identical(finalStandings, _sentinel)
          ? this.finalStandings
          : finalStandings as List<PlayerModel>?,
      bettingStarterIndex: bettingStarterIndex ?? this.bettingStarterIndex,
      claimHistory: claimHistory ?? this.claimHistory,
      eliminated: eliminated ?? this.eliminated,
    );
  }
}
