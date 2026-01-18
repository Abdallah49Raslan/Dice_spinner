// liars_dice_engine.dart
import '../actions/call_liar_action.dart';
import '../actions/claim_action.dart';
import '../actions/confirm_next_action.dart';
import '../actions/game_action.dart';
import '../actions/next_round_action.dart';
import '../actions/roll_action.dart';
import '../entities/claim_history_item.dart';
import '../entities/claim_model.dart';
import '../entities/game_config.dart';
import '../entities/game_phase.dart';
import '../entities/player_model.dart';
import '../entities/round_result.dart';
import '../state/liars_dice_state.dart';

class NextRoundOutcome {
  final LiarsDiceState state;
  final List<PlayerModel> eliminated;

  const NextRoundOutcome({required this.state, required this.eliminated});
}

class LiarsDiceEngine {
  final GameConfig config;

  const LiarsDiceEngine({required this.config});

  // ------------------------------------------------------------
  // ACTION FACADE (pre-online ready)
  // ------------------------------------------------------------
  LiarsDiceState applyAction({
    required LiarsDiceState state,
    required GameAction action,
  }) {
    if (action is RollAction) {
      return rollCurrentPlayer(
        state: state,
        currentIndex: action.playerIndex,
        newDice: action.dice,
      );
    }

    if (action is ConfirmNextAction) {
      return confirmRollNext(state);
    }

    if (action is ClaimAction) {
      return makeClaim(state: state, newBid: action.claim);
    }

    if (action is CallLiarAction) {
      return callLiar(state);
    }

    if (action is NextRoundAction) {
      return nextRound(state);
    }

    return state;
  }

  // ------------------------------------------------------------
  // ROLL (pure)
  // ------------------------------------------------------------
  LiarsDiceState rollCurrentPlayer({
    required LiarsDiceState state,
    required int currentIndex,
    required List<int> newDice,
  }) {
    if (state.gameOver) return state;
    if (state.phase != GamePhase.rolling) return state;
    if (state.players.isEmpty) return state;
    if (state.rollLocked) return state;
    if (state.awaitingNext) return state;

    final idx = _safeIndex(currentIndex, state.players.length);

    final players = [...state.players];
    final current = players[idx];
    players[idx] = current.copyWith(dice: newDice);

    final rolled = (state.hasRolled.length == players.length)
        ? [...state.hasRolled]
        : List<bool>.filled(players.length, false);

    rolled[idx] = true;

    final allRolled = rolled.isNotEmpty && rolled.every((e) => e);

    int? nextIndex;
    if (!allRolled) {
      int next = (idx + 1) % players.length;
      int guard = 0;
      while (rolled[next] && guard < players.length) {
        next = (next + 1) % players.length;
        guard++;
      }
      nextIndex = next;
    }

    return state.copyWith(
      players: players,
      hasRolled: rolled,
      showDice: true,
      spinToken: state.spinToken + 1,
      rollLocked: true,
      awaitingNext: true,
      pendingNextIndex: nextIndex,
      pendingAllRolled: allRolled,
      diceAnimating: true,
    );
  }

  // ------------------------------------------------------------
  // NEXT (pure)
  // ------------------------------------------------------------
  LiarsDiceState confirmRollNext(LiarsDiceState state) {
    if (state.gameOver) return state;
    if (state.phase != GamePhase.rolling) return state;
    if (!state.awaitingNext) return state;
    if (state.diceAnimating) return state;

    final allRolled = state.pendingAllRolled;

    if (allRolled) {
      final starter = _safeIndex(
        state.bettingStarterIndex,
        state.players.length,
      );
      return state.copyWith(
        showDice: false,
        rollLocked: false,
        awaitingNext: false,
        pendingNextIndex: null,
        pendingAllRolled: false,
        phase: GamePhase.betting,
        currentPlayerIndex: starter,
        currentClaim: null,
        callerIndex: null,
        lastRoundResult: null,
        claimHistory: const [],
      );
    }

    final next = state.pendingNextIndex;
    final safeNext = _safeIndex(next ?? 0, state.players.length);

    return state.copyWith(
      showDice: false,
      rollLocked: false,
      awaitingNext: false,
      pendingNextIndex: null,
      pendingAllRolled: false,
      phase: GamePhase.rolling,
      currentPlayerIndex: safeNext,
    );
  }

  // ------------------------------------------------------------
  // BETTING (raise only) + HISTORY (pure)
  // ------------------------------------------------------------
  LiarsDiceState makeClaim({
    required LiarsDiceState state,
    required ClaimModel newBid,
  }) {
    if (state.gameOver) return state;
    if (state.phase != GamePhase.betting) return state;
    if (state.showDice) return state;

    final allRolled =
        state.hasRolled.isNotEmpty && state.hasRolled.every((e) => e);
    if (!allRolled) return state;

    if (config.onesAreWild && newBid.face == 1) return state;

    final prev = state.currentClaim;
    if (prev != null) {
      final higherQty = newBid.quantity > prev.quantity;
      final sameQtyHigherFace =
          newBid.quantity == prev.quantity && newBid.face > prev.face;
      if (!higherQty && !sameQtyHigherFace) return state;
    }

    final claimerIndex = _safeIndex(
      state.currentPlayerIndex,
      state.players.length,
    );
    final claimerName = state.players[claimerIndex].name;

    final newHistory = [
      ...state.claimHistory,
      ClaimHistoryItem(playerName: claimerName, claim: newBid),
    ];

    return state.copyWith(
      currentClaim: newBid,
      claimHistory: newHistory,
      currentPlayerIndex: (state.currentPlayerIndex + 1) % state.players.length,
      phase: GamePhase.betting,
    );
  }

  // ------------------------------------------------------------
  // CALL LIAR (pure)
  // ------------------------------------------------------------
  LiarsDiceState callLiar(LiarsDiceState state) {
    if (state.gameOver) return state;
    if (state.phase != GamePhase.betting) return state;
    if (state.currentClaim == null) return state;

    final claim = state.currentClaim!;
    final actualCount = countFaceAcrossAllPlayers(state.players, claim.face);
    final bool claimIsTrue = actualCount >= claim.quantity;

    final caller = _safeIndex(state.currentPlayerIndex, state.players.length);
    final claimer = (caller - 1 + state.players.length) % state.players.length;

    final winnerIndex = claimIsTrue ? claimer : caller;
    final loserIndex = claimIsTrue ? caller : claimer;

    final snapshot = state.players.map((p) => p.copyWith()).toList();

    return state.copyWith(
      phase: GamePhase.reveal,
      callerIndex: caller,
      lastRoundResult: RoundResult(
        claim: claim,
        claimIsTrue: claimIsTrue,
        winnerIndex: winnerIndex,
        loserIndex: loserIndex,
        playersSnapshot: snapshot,
      ),
    );
  }

  // ------------------------------------------------------------
  // NEXT ROUND (pure + returns eliminated list)
  // ------------------------------------------------------------

  LiarsDiceState nextRound(LiarsDiceState state) {
    if (state.gameOver) return state;
    if (state.phase != GamePhase.reveal) return state;

    final result = state.lastRoundResult;
    if (result == null) return state;

    final winnerIndex = result.winnerIndex;
    final loserIndex = result.loserIndex;

    if (state.players.isEmpty) return state;
    if (loserIndex < 0 || loserIndex >= state.players.length) return state;

    final updatedPlayers = [...state.players];
    final loser = updatedPlayers[loserIndex];

    final newDiceCount = loser.dice.length - 1;
    bool removed = false;

    // ✅ eliminated moved into state.core
    final nextEliminated = [...state.eliminated];

    if (newDiceCount > 0) {
      updatedPlayers[loserIndex] = loser.copyWith(
        dice: loser.dice.sublist(0, newDiceCount),
      );
    } else {
      nextEliminated.add(loser);
      updatedPlayers.removeAt(loserIndex);
      removed = true;
    }

    if (updatedPlayers.length == 1) {
      final winner = updatedPlayers.first;
      final standings = <PlayerModel>[winner, ...nextEliminated.reversed];

      return state.copyWith(
        players: updatedPlayers,
        currentPlayerIndex: 0,
        phase: GamePhase.rolling,
        currentClaim: null,
        callerIndex: null,
        showDice: false,
        hasRolled: const [],
        rollLocked: false,
        awaitingNext: false,
        pendingNextIndex: null,
        pendingAllRolled: false,
        gameOver: true,
        finalStandings: standings,
        claimHistory: const [],
        eliminated: nextEliminated, // ✅
      );
    }

    int adjustedWinner = winnerIndex;
    if (removed && loserIndex < winnerIndex) {
      adjustedWinner = winnerIndex - 1;
    }

    final safeWinner = _safeIndex(adjustedWinner, updatedPlayers.length);

    return state.copyWith(
      players: updatedPlayers,
      currentPlayerIndex: safeWinner,
      phase: GamePhase.rolling,
      currentClaim: null,
      callerIndex: null,
      lastRoundResult: result,
      showDice: false,
      hasRolled: List<bool>.filled(updatedPlayers.length, false),
      rollLocked: false,
      awaitingNext: false,
      pendingNextIndex: null,
      pendingAllRolled: false,
      bettingStarterIndex: safeWinner,
      claimHistory: const [],
      eliminated: nextEliminated, // ✅
    );
  }

  int countFaceAcrossAllPlayers(List<PlayerModel> players, int face) {
    int count = 0;
    for (final p in players) {
      for (final d in p.dice) {
        if (d == face) {
          count++;
        } else if (config.onesAreWild && d == 1 && face != 1) {
          count++;
        }
      }
    }
    return count;
  }

  int _safeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return 0;
    return index;
  }
}
