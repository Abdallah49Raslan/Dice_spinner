// ignore_for_file: invalid_use_of_protected_member
import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:dice/features/normal_dice/cubit/dice_state.dart';
import 'package:dice/features/normal_dice/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/dice_constants.dart';

class DiceSpinnerPage extends StatefulWidget {
  const DiceSpinnerPage({super.key});

  @override
  State<DiceSpinnerPage> createState() => _DiceSpinnerPageState();
}

class _DiceSpinnerPageState extends State<DiceSpinnerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: DiceConstants.baseSpinDuration,
    );

    _rotation = CurvedAnimation(
      parent: _controller,
      curve: DiceConstants.spinCurve, // easeOutCubic
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    final cubit = context.read<DiceCubit>();
    if (cubit.state.isSpinning) return;

    // ابدأ اللف (Cubit)
    cubit.startSpin();

    // نفس إحساس السرعة القديم
    final durationMs =
        DiceConstants.baseSpinDuration.inMilliseconds +
        (cubit.state.extraSteps * DiceConstants.extraStepDurationMs);

    _controller.duration = Duration(milliseconds: durationMs);
    _controller.reset();

    int lastTick = 0;

    // تغيير الوجه أثناء اللف (بمعدل مريح للعين)
    final ticker = Ticker((elapsed) {
      if (elapsed.inMilliseconds - lastTick >= 100) {
        lastTick = elapsed.inMilliseconds;
        cubit.emit(cubit.state.copyWith(face1: cubit.randomFace()));
      }
    });

    ticker.start();
    await _controller.forward();

    ticker.stop();
    ticker.dispose();

    // الوجه النهائي
    cubit.emit(
      cubit.state.copyWith(face1: cubit.randomFace(), isSpinning: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _spin,
          child: Center(
            // ❗ مفيش Transform هنا
            child: DiceFaceView(
              face: state.face1,
              rotation: _rotation, // 👈 اللف يحصل هنا فقط
            ),
          ),
        );
      },
    );
  }
}
