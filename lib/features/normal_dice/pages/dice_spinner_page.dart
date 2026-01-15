// ignore_for_file: invalid_use_of_protected_member

import 'package:dice/features/liars_dice/widgets/animated_dice_view.dart';
import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:dice/features/normal_dice/cubit/dice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiceSpinnerPage extends StatelessWidget {
  const DiceSpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(
      builder: (context, state) {
        final cubit = context.read<DiceCubit>();

        return Center(
          child: AnimatedDiceView(
            face: state.face1,
            enableTapSpin: true,

            // ✅ إظهار اللابل (لو AnimatedDiceView بيمرّرها لـ DiceFaceView)
            showLabel: true,

            // أثناء اللف (tick)
            tickFacePicker: () => cubit.randomFace(),

            // الوجه النهائي
            finishFacePicker: () => cubit.randomFace(),

            // لو عايز تفضل محافظ على state updates في cubit
            onTickFace: (f) => cubit.emit(cubit.state.copyWith(face1: f)),
            onFinishFace: (f) =>
                cubit.emit(cubit.state.copyWith(face1: f, isSpinning: false)),
          ),
        );
      },
    );
  }
}
