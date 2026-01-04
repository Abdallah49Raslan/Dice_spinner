import '../../core/constants/dice_constants.dart';
import 'package:flutter/material.dart';

@immutable

class DiceState {
  final bool isRolling;
  final int diceCount;
  final List<int> diceValues;

  const DiceState({
    required this.isRolling,
    required this.diceCount,
    required this.diceValues,
  });

  const DiceState.initial()
      : isRolling = false,
        diceCount = DiceConstants.singleDice,
        diceValues = const [];

  DiceState copyWith({
    bool? isRolling,
    int? diceCount,
    List<int>? diceValues,
  }) {
    return DiceState(
      isRolling: isRolling ?? this.isRolling,
      diceCount: diceCount ?? this.diceCount,
      diceValues: diceValues ?? this.diceValues,
    );
  }
}
