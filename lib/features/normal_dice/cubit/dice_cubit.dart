import 'dart:math';

import '../../../core/constants/dice_constants.dart';
import 'dice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiceCubit extends Cubit<DiceState> {
  DiceCubit() : super(const DiceState.initial());

  final Random _rng = Random();

  int randomFace() =>
      DiceConstants.minFace +
      _rng.nextInt(DiceConstants.facesCount);

  void startSpin() {
    if (state.isSpinning) return;

    final extraSteps =
        DiceConstants.minExtraSteps +
        _rng.nextInt(
          DiceConstants.maxExtraSteps - DiceConstants.minExtraSteps,
        );

    emit(
      state.copyWith(
        isSpinning: true,
        extraSteps: extraSteps,
      ),
    );
  }

  void updateFaces() {
    emit(
      state.copyWith(
        face1: randomFace(),
        face2: randomFace(),
      ),
    );
  }

  void endSpin() {
    emit(
      state.copyWith(
        face1: randomFace(),
        face2: randomFace(),
        isSpinning: false,
      ),
    );
  }
}
