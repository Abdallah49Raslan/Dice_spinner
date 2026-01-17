import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/claim_model.dart';
import '../models/game_config.dart';
import '../models/game_phase.dart';
import '../models/player_model.dart';
import '../models/round_result.dart';
import 'liars_dice_state.dart';

class LiarsDiceCubit extends Cubit<LiarsDiceState> {
  final Random _random = Random();
  final GameConfig config;

  final List<PlayerModel> _eliminated = [];

  LiarsDiceCubit({required List<String> playerNames, required this.config})
    : super(_buildInitialState(playerNames, config));

  static LiarsDiceState _buildInitialState(
    List<String> playerNames,
    GameConfig config,
  ) {
    final players = playerNames
        .map(
          (name) => PlayerModel(
            name: name,
            dice: List.filled(config.dicePerPlayer, 0),
          ),
        )
        .toList();

    // ✅ أول راوند: Starter عشوائي بدل Player1 دائمًا
    final starter = players.isEmpty ? 0 : Random().nextInt(players.length);

    return LiarsDiceState(
      players: players,
      currentPlayerIndex: starter,
      phase: GamePhase.rolling,
      currentClaim: null,
      callerIndex: null,
      lastRoundResult: null,
      showDice: false,
      hasRolled: List.filled(players.length, false),
      spinToken: 0,
      gameOver: false,
      finalStandings: null,
      rollLocked: false,
      awaitingNext: false,
      pendingNextIndex: null,
      pendingAllRolled: false,
      bettingStarterIndex: starter, // ✅ الفائز/الستارتر يبدأ claim
    );
  }

  // ------------------------------------------------------------
  // ROLL (no delay). After roll -> show dice + lock + awaitingNext
  // ------------------------------------------------------------
  void rollCurrentPlayer() {
    if (state.gameOver) return;
    if (state.phase != GamePhase.rolling) return;
    if (state.players.isEmpty) return;
    if (state.rollLocked) return;
    if (state.awaitingNext) return;

    final idx = _safeIndex(state.currentPlayerIndex, state.players.length);

    final players = [...state.players];
    final current = players[idx];

    final newDice = List.generate(
      current.dice.length,
      (_) => _random.nextInt(6) + 1,
    );
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

    emit(
      state.copyWith(
        players: players,
        hasRolled: rolled,
        showDice: true,
        spinToken: state.spinToken + 1,
        rollLocked: true,
        awaitingNext: true,
        pendingNextIndex: nextIndex,
        pendingAllRolled: allRolled,

        // ✅ جديد
        diceAnimating: true,
      ),
    );

    // ✅ بعد ما الأنيميشن يخلص فعلاً
    Future.delayed(const Duration(milliseconds: 900), () {
      if (isClosed) return;
      emit(state.copyWith(diceAnimating: false));
    });
  }

  // ------------------------------------------------------------
  // NEXT (after showing dice) - hide dice and move forward
  // ------------------------------------------------------------
  void confirmRollNext() {
    if (state.gameOver) return;
    if (state.phase != GamePhase.rolling) return;
    if (!state.awaitingNext) return;

     if (state.diceAnimating) return;

    final allRolled = state.pendingAllRolled;

    if (allRolled) {
      // ✅ ابدأ betting من الفائز (bettingStarterIndex)
      final starter = _safeIndex(
        state.bettingStarterIndex,
        state.players.length,
      );

      emit(
        state.copyWith(
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
        ),
      );
      return;
    }

    final next = state.pendingNextIndex;
    final safeNext = _safeIndex(next ?? 0, state.players.length);

    emit(
      state.copyWith(
        showDice: false,
        rollLocked: false,
        awaitingNext: false,
        pendingNextIndex: null,
        pendingAllRolled: false,
        phase: GamePhase.rolling,
        currentPlayerIndex: safeNext,
      ),
    );
  }

  // ------------------------------------------------------------
  // BETTING (raise only)
  // ------------------------------------------------------------
  void makeClaim(ClaimModel newBid) {
    if (state.gameOver) return;
    if (state.phase != GamePhase.betting) return;
    if (state.showDice) return;

    final allRolled =
        state.hasRolled.isNotEmpty && state.hasRolled.every((e) => e);
    if (!allRolled) return;

    // Hard only: forbid bidding on face=1 (per your rule)
    if (config.onesAreWild && newBid.face == 1) return;

    final prev = state.currentClaim;
    if (prev != null) {
      final higherQty = newBid.quantity > prev.quantity;
      final sameQtyHigherFace =
          newBid.quantity == prev.quantity && newBid.face > prev.face;
      if (!higherQty && !sameQtyHigherFace) return;
    }

    emit(
      state.copyWith(
        currentClaim: newBid,
        currentPlayerIndex:
            (state.currentPlayerIndex + 1) % state.players.length,
        phase: GamePhase.betting,
      ),
    );
  }

  // ------------------------------------------------------------
  // CALL LIAR => reveal result
  // ------------------------------------------------------------
  void callLiar() {
    if (state.gameOver) return;
    if (state.phase != GamePhase.betting) return;
    if (state.currentClaim == null) return;

    final claim = state.currentClaim!;
    final actualCount = countFaceAcrossAllPlayers(claim.face);
    final bool claimIsTrue = actualCount >= claim.quantity;

    final caller = _safeIndex(state.currentPlayerIndex, state.players.length);
    final claimer = (caller - 1 + state.players.length) % state.players.length;

    final winnerIndex = claimIsTrue ? claimer : caller;
    final loserIndex = claimIsTrue ? caller : claimer;

    final snapshot = state.players.map((p) => p.copyWith()).toList();

    emit(
      state.copyWith(
        phase: GamePhase.reveal,
        callerIndex: caller,
        lastRoundResult: RoundResult(
          claim: claim,
          claimIsTrue: claimIsTrue,
          winnerIndex: winnerIndex,
          loserIndex: loserIndex,
          playersSnapshot: snapshot,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // NEXT ROUND
  // - loser loses die, may be removed
  // - winner starts next round (rolling) AND starts betting later
  // ------------------------------------------------------------
  void nextRound() {
    if (state.gameOver) return;
    if (state.phase != GamePhase.reveal) return;

    final result = state.lastRoundResult;
    if (result == null) return;

    final winnerIndex = result.winnerIndex;
    final loserIndex = result.loserIndex;

    if (state.players.isEmpty) return;
    if (loserIndex < 0 || loserIndex >= state.players.length) return;

    final updatedPlayers = [...state.players];
    final loser = updatedPlayers[loserIndex];

    final newDiceCount = loser.dice.length - 1;
    bool removed = false;

    if (newDiceCount > 0) {
      updatedPlayers[loserIndex] = loser.copyWith(
        dice: loser.dice.sublist(0, newDiceCount),
      );
    } else {
      _eliminated.add(loser);
      updatedPlayers.removeAt(loserIndex);
      removed = true;
    }

    if (updatedPlayers.length == 1) {
      final winner = updatedPlayers.first;
      final standings = <PlayerModel>[winner, ..._eliminated.reversed];

      emit(
        state.copyWith(
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
        ),
      );
      return;
    }

    int adjustedWinner = winnerIndex;
    if (removed && loserIndex < winnerIndex) {
      adjustedWinner = winnerIndex - 1;
    }

    final safeWinner = _safeIndex(adjustedWinner, updatedPlayers.length);

    emit(
      state.copyWith(
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
        bettingStarterIndex: safeWinner, // ✅ الفائز يبدأ claim بعد كل الرول
      ),
    );
  }

  int countFaceAcrossAllPlayers(int face) {
    int count = 0;
    for (final p in state.players) {
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
