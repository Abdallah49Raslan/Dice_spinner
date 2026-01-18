// liars_dice_cubit.dart
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/actions/call_liar_action.dart';
import '../../../domain/actions/claim_action.dart';
import '../../../domain/actions/confirm_next_action.dart';
import '../../../domain/actions/roll_action.dart';
import '../../../domain/engine/liars_dice_engine.dart';
import '../../../domain/entities/claim_model.dart';
import '../../../domain/entities/game_config.dart';
import '../../../domain/entities/game_phase.dart';
import '../../../domain/entities/player_model.dart';
import '../../../domain/state/liars_dice_core_state.dart';
import '../../../domain/state/liars_dice_state.dart';
import '../../../domain/state/liars_dice_view_state.dart';
import '../../../domain/actions/next_round_action.dart';


class LiarsDiceCubit extends Cubit<LiarsDiceState> {
  final Random _random;
  final GameConfig config;
  final LiarsDiceEngine _engine;


  LiarsDiceCubit({
    required List<String> playerNames,
    required this.config,
    Random? random,
  }) : _random = random ?? Random(),
       _engine = LiarsDiceEngine(config: config),
       super(_buildInitialState(playerNames, config, random ?? Random()));

  static LiarsDiceState _buildInitialState(
    List<String> playerNames,
    GameConfig config,
    Random random,
  ) {
    final players = playerNames
        .map(
          (name) => PlayerModel(
            name: name,
            dice: List.filled(config.dicePerPlayer, 0),
          ),
        )
        .toList();

    final starter = players.isEmpty ? 0 : random.nextInt(players.length);

    final core = LiarsDiceCoreState(
      players: players,
      currentPlayerIndex: starter,
      phase: GamePhase.rolling,
      currentClaim: null,
      callerIndex: null,
      lastRoundResult: null,
      hasRolled: List.filled(players.length, false),
      gameOver: false,
      finalStandings: null,
      bettingStarterIndex: starter,
      claimHistory: const [],
    );

    final view = const LiarsDiceViewState(
      showDice: false,
      spinToken: 0,
      diceAnimating: false,
      rollLocked: false,
      awaitingNext: false,
      pendingNextIndex: null,
      pendingAllRolled: false,
    );

    return LiarsDiceState(core: core, view: view);
  }

  void rollCurrentPlayer() {
    if (state.gameOver) return;
    if (state.phase != GamePhase.rolling) return;
    if (state.players.isEmpty) return;
    if (state.rollLocked) return;
    if (state.awaitingNext) return;

    final idx = _safeIndex(state.currentPlayerIndex, state.players.length);
    final current = state.players[idx];

    final newDice = List.generate(
      current.dice.length,
      (_) => _random.nextInt(6) + 1,
    );

    emit(
      _engine.applyAction(
        state: state,
        action: RollAction(playerIndex: idx, dice: newDice),
      ),
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      if (isClosed) return;
      emit(state.copyWith(diceAnimating: false));
    });
  }

  void confirmRollNext() {
    emit(_engine.applyAction(state: state, action: const ConfirmNextAction()));
  }

  void makeClaim(ClaimModel newBid) {
    emit(
      _engine.applyAction(
        state: state,
        action: ClaimAction(claim: newBid),
      ),
    );
  }

  void callLiar() {
    emit(_engine.applyAction(state: state, action: const CallLiarAction()));
  }

 void nextRound() {
  emit(_engine.applyAction(state: state, action: const NextRoundAction()));
}

  int _safeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return 0;
    return index;
  }
}
