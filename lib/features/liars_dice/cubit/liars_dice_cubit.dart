// liars_dice_cubit.dart
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

  // ✅ لتجميع ترتيب الخروج (أول واحد يخرج يتخزن أول)
  final List<PlayerModel> _eliminated = [];

  LiarsDiceCubit({required List<String> playerNames, required this.config})
    : super(
        LiarsDiceState(
          players: playerNames
              .map(
                (name) => PlayerModel(
                  name: name,
                  // 0 = not rolled yet
                  dice: List.filled(config.dicePerPlayer, 0),
                ),
              )
              .toList(),
          currentPlayerIndex: 0,
          phase: GamePhase.rolling,
          currentClaim: null,
          callerIndex: null,
          lastRoundResult: null,
          showDice: false,
          hasRolled: List.filled(playerNames.length, false),
          spinToken: 0,
          gameOver: false,
          finalStandings: null,
        ),
      );

  // ------------------------------------------------------------
  // ROLLING PHASE (each player rolls once)
  // ------------------------------------------------------------
  Future<void> rollCurrentPlayer() async {
    if (state.gameOver) return;
    if (state.phase != GamePhase.rolling) return;
    if (state.players.isEmpty) return;

    final idx = _safeIndex(state.currentPlayerIndex, state.players.length);

    final players = [...state.players];
    final current = players[idx];

    final newDice = List.generate(
      current.dice.length,
      (_) => _random.nextInt(6) + 1,
    );
    players[idx] = current.copyWith(dice: newDice);

    // ensure hasRolled length matches players length
    final rolled = (state.hasRolled.length == players.length)
        ? [...state.hasRolled]
        : List<bool>.filled(players.length, false);

    rolled[idx] = true;

    emit(
      state.copyWith(
        players: players,
        hasRolled: rolled,
        showDice: true,
        spinToken: state.spinToken + 1,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    final allRolled = rolled.isNotEmpty && rolled.every((e) => e);

    if (allRolled) {
      emit(
        state.copyWith(
          showDice: false,
          phase: GamePhase.betting,
          currentPlayerIndex: 0,
          currentClaim: null,
          callerIndex: null,
          lastRoundResult: null,
        ),
      );
      return;
    }

    // move to next player who has not rolled
    int next = (idx + 1) % players.length;
    int guard = 0;
    while (rolled[next] && guard < players.length) {
      next = (next + 1) % players.length;
      guard++;
    }

    emit(
      state.copyWith(
        showDice: false,
        phase: GamePhase.rolling,
        currentPlayerIndex: next,
      ),
    );
  }

  // ------------------------------------------------------------
  // BETTING (raise only)
  // Hard only: if onesAreWild==true => forbid face=1 bid (per your rules)
  // ------------------------------------------------------------
  void makeClaim(ClaimModel newBid) {
    if (state.gameOver) return;
    if (state.phase != GamePhase.betting) return;
    if (state.showDice) return;

    final allRolled =
        state.hasRolled.isNotEmpty && state.hasRolled.every((e) => e);
    if (!allRolled) return;

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
  // CALL LIAR => produce lastRoundResult + move to reveal
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
  // - subtract 1 die from loser
  // - if loser reaches 0 => remove + store in _eliminated
  // - if only 1 player remains => gameOver + finalStandings
  // - otherwise => winner starts next rolling round
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
      // ✅ eliminated
      _eliminated.add(loser);
      updatedPlayers.removeAt(loserIndex);
      removed = true;
    }

    // ✅ if only one remains => game over
    if (updatedPlayers.length == 1) {
      final winner = updatedPlayers.first;

      final standings = <PlayerModel>[
        winner,
        ..._eliminated.reversed, // last eliminated becomes 2nd
      ];

      emit(
        state.copyWith(
          players: updatedPlayers,
          currentPlayerIndex: 0,
          phase: GamePhase.rolling,
          currentClaim: null,
          callerIndex: null,
          lastRoundResult: result, // keep to show last reveal if needed
          showDice: false,
          hasRolled: const [],
          gameOver: true,
          finalStandings: standings,
        ),
      );
      return;
    }

    // adjust winner index if loser removed before it
    int adjustedWinner = winnerIndex;
    if (removed && loserIndex < winnerIndex) {
      adjustedWinner = winnerIndex - 1;
    }

    // clamp to range (fix RangeError)
    final safeWinner = _safeIndex(adjustedWinner, updatedPlayers.length);

    emit(
      state.copyWith(
        players: updatedPlayers,
        currentPlayerIndex: safeWinner,
        phase: GamePhase.rolling,
        currentClaim: null,
        callerIndex: null,
        showDice: false,
        hasRolled: List<bool>.filled(updatedPlayers.length, false),
        // اختيارياً: تصفير lastRoundResult هنا لو مش عايزها تفضل
        // lastRoundResult: null,
      ),
    );
  }

  // ------------------------------------------------------------
  // COUNT
  // Hard: onesAreWild => 1 counts for any face except 1
  // ------------------------------------------------------------
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

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------
  int _safeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return 0;
    return index;
  }
}
