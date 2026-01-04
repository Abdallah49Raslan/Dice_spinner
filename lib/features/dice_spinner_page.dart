import 'cubit/dice_state.dart';
import 'widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/dice_constants.dart';
import 'cubit/dice_cubit.dart';

class DiceSpinnerPage extends StatelessWidget {
  const DiceSpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiceCubit(),
      child: BlocBuilder<DiceCubit, DiceState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => context.read<DiceCubit>().roll(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(state.diceCount, (index) {
                final value = state.diceValues.isNotEmpty
                    ? state.diceValues[index]
                    : DiceConstants.minFace;

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: DiceFaceView(face: value),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
