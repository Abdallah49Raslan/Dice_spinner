import 'dart:math';

import 'dice_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/dice_constants.dart';

class DiceCubit extends Cubit<DiceState> {
  DiceCubit() : super(const DiceState.initial());

  final Random _rng = Random();

  int randomFace() =>
      DiceConstants.minFace + _rng.nextInt(DiceConstants.facesCount);

  void startSpin() {
    if (state.isSpinning) return;

    final extraSteps = DiceConstants.minExtraSteps +
        _rng.nextInt(DiceConstants.maxExtraSteps - DiceConstants.minExtraSteps);

    emit(
      state.copyWith(
        isSpinning: true,
        extraSteps: extraSteps,
      ),
    );
  }

  /// ✅ Token يزيد مع كل spin علشان Widgets زي DiceSpinView تلتقط التغيير وتبدأ أنيميشن
  void bumpSpinToken() {
    emit(state.copyWith(spinToken: state.spinToken + 1));
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
