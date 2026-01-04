import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/dice_constants.dart';
import 'dice_state.dart';

class DiceCubit extends Cubit<DiceState> {
  DiceCubit() : super(const DiceState.initial());

  final Random _rng = Random();

  void onPageChanged(int pageIndex) {
    final face =
        (pageIndex % DiceConstants.facesCount) + DiceConstants.minFace;

    if (face != state.face) {
      emit(state.copyWith(face: face));
    }
  }

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

  void endSpin() {
    if (!state.isSpinning) return;
    emit(state.copyWith(isSpinning: false));
  }
}
