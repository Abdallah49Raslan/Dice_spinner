import 'dart:math';

import 'package:bloc/bloc.dart';

import '../../../core/constants/dice_constants.dart';
import 'dice_state.dart';

class DiceCubit extends Cubit<DiceState> {
  DiceCubit() : super(const DiceState.initial());

  final Random _rng = Random();

  void roll() {
    final diceCount = state.diceCount;

    final values = List.generate(
      diceCount,
      (_) => DiceConstants.minFace + _rng.nextInt(DiceConstants.facesCount),
    );

    emit(state.copyWith(isRolling: false, diceValues: values));
  }

  void toggleDiceCount() {
    emit(
      state.copyWith(
        diceCount: state.diceCount == DiceConstants.singleDice
            ? DiceConstants.doubleDice
            : DiceConstants.singleDice,
        diceValues: const [],
      ),
    );
  }
}
