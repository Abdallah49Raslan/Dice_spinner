import '../entities/claim_history_item.dart';
import '../entities/claim_model.dart';
import '../entities/game_phase.dart';
import '../entities/player_model.dart';
import '../entities/round_result.dart';
import 'liars_dice_core_state.dart';
import 'liars_dice_view_state.dart';

class LiarsDiceState {
  final LiarsDiceCoreState core;
  final LiarsDiceViewState view;

  const LiarsDiceState({required this.core, required this.view});

  // ---- Backward-compatible getters (so UI stays unchanged) ----
  List<PlayerModel> get players => core.players;
  int get currentPlayerIndex => core.currentPlayerIndex;
  GamePhase get phase => core.phase;

  ClaimModel? get currentClaim => core.currentClaim;
  int? get callerIndex => core.callerIndex;
  RoundResult? get lastRoundResult => core.lastRoundResult;

  List<bool> get hasRolled => core.hasRolled;
  bool get gameOver => core.gameOver;
  List<PlayerModel>? get finalStandings => core.finalStandings;

  int get bettingStarterIndex => core.bettingStarterIndex;
  List<ClaimHistoryItem> get claimHistory => core.claimHistory;

  bool get showDice => view.showDice;
  int get spinToken => view.spinToken;
  bool get diceAnimating => view.diceAnimating;

  bool get rollLocked => view.rollLocked;
  bool get awaitingNext => view.awaitingNext;
  int? get pendingNextIndex => view.pendingNextIndex;
  bool get pendingAllRolled => view.pendingAllRolled;
  List<PlayerModel> get eliminated => core.eliminated;


  static const _sentinel = Object();

  LiarsDiceState copyWith({
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

    bool? showDice,
    int? spinToken,
    bool? diceAnimating,
    bool? rollLocked,
    bool? awaitingNext,
    Object? pendingNextIndex = _sentinel,
    bool? pendingAllRolled,
  }) {
    final nextCore = core.copyWith(
      players: players,
      currentPlayerIndex: currentPlayerIndex,
      phase: phase,
      currentClaim: currentClaim,
      callerIndex: callerIndex,
      lastRoundResult: lastRoundResult,
      hasRolled: hasRolled,
      gameOver: gameOver,
      finalStandings: finalStandings,
      bettingStarterIndex: bettingStarterIndex,
      claimHistory: claimHistory,
       eliminated: eliminated,
    );

    final nextView = view.copyWith(
      showDice: showDice,
      spinToken: spinToken,
      diceAnimating: diceAnimating,
      rollLocked: rollLocked,
      awaitingNext: awaitingNext,
      pendingNextIndex: pendingNextIndex,
      pendingAllRolled: pendingAllRolled,
    );

    return LiarsDiceState(core: nextCore, view: nextView);
  }
}
