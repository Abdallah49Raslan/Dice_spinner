// ignore_for_file: invalid_use_of_protected_member

import 'package:dice/features/liars_dice/widgets/animated_dice_view.dart';
import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:dice/features/normal_dice/cubit/dice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TwoDiceSpinnerPage extends StatelessWidget {
  const TwoDiceSpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(
      builder: (context, state) {
        final cubit = context.read<DiceCubit>();

        return GestureDetector(
          onTap: () {
            if (cubit.state.isSpinning) return;
            cubit.startSpin();

            // ✅ trigger واحد يشغل الاتنين مع بعض
            // لازم يكون عندك في DiceCubit متغير spinToken يزيد +1 كل مرة
            // أو تعمل cubit.bumpSpinToken()
            cubit.bumpSpinToken();
          },
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedDiceView(
                    face: state.face1,
                    spinToken: state.spinToken, // ✅ نفس التوكن للاتنين
                    showBackground: true,
                    showLabel: true,
                    tickFacePicker: () => cubit.randomFace(),
                    finishFacePicker: () => cubit.randomFace(),
                    onTickFace: (f) =>
                        cubit.emit(cubit.state.copyWith(face1: f)),
                    onFinishFace: (f) {
                      // ✅ لما الأول يخلص، ثبت face1
                      final next = cubit.state.copyWith(face1: f);
                      cubit.emit(next);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedDiceView(
                    face: state.face2,
                    spinToken: state.spinToken, // ✅ نفس التوكن للاتنين
                    showBackground: true,
                    showLabel: true,
                    tickFacePicker: () => cubit.randomFace(),
                    finishFacePicker: () => cubit.randomFace(),
                    onTickFace: (f) =>
                        cubit.emit(cubit.state.copyWith(face2: f)),
                    onFinishFace: (f) {
                      // ✅ ثبت face2 وبعدين اقفل isSpinning
                      cubit.emit(
                        cubit.state.copyWith(face2: f, isSpinning: false),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
