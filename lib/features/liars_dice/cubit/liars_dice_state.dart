import '../models/claim_model.dart';
import '../models/game_phase.dart';
import '../models/player_model.dart';
import '../models/round_result.dart';
import '../models/claim_history_item.dart';


class LiarsDiceState {
  final List<PlayerModel> players;
  final int currentPlayerIndex;
  final GamePhase phase;

  final ClaimModel? currentClaim;
  final int? callerIndex;
  final RoundResult? lastRoundResult;

  final bool showDice;

  final List<bool> hasRolled;
  final int spinToken;

  final bool gameOver;
  final List<PlayerModel>? finalStandings;
  final bool diceAnimating; // ✅ جديد


  // ✅ جديد
  final bool rollLocked; // يمنع الضغط أثناء اللف/العرض
  final bool awaitingNext; // بعد الرول نستنى Next
  final int? pendingNextIndex; // مين اللي بعده يرول
  final bool pendingAllRolled; // هل الكل رول
  final int bettingStarterIndex; // مين يبدأ الـ claim (الفائز)
  final List<ClaimHistoryItem> claimHistory;

  

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
    this.diceAnimating = false,
    required this.claimHistory,




    // ✅ جديد
    this.rollLocked = false,
    this.awaitingNext = false,
    this.pendingNextIndex,
    this.pendingAllRolled = false,
    this.bettingStarterIndex = 0,
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

    // ✅ جديد
    bool? rollLocked,
    bool? awaitingNext,
    Object? pendingNextIndex = _sentinel,
    bool? pendingAllRolled,
    int? bettingStarterIndex,
    bool? diceAnimating,
    List<ClaimHistoryItem>? claimHistory,


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

      // ✅ جديد
      rollLocked: rollLocked ?? this.rollLocked,
      awaitingNext: awaitingNext ?? this.awaitingNext,
      pendingNextIndex: identical(pendingNextIndex, _sentinel)
          ? this.pendingNextIndex
          : pendingNextIndex as int?,
      pendingAllRolled: pendingAllRolled ?? this.pendingAllRolled,
      bettingStarterIndex: bettingStarterIndex ?? this.bettingStarterIndex,
      diceAnimating: diceAnimating ?? this.diceAnimating,
      claimHistory: claimHistory ?? this.claimHistory,


    );
  }
}
