import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/dice_constants.dart';
import '../cubit/dice_cubit.dart';
import '../cubit/dice_state.dart';
import '../widgets/dice_face_view.dart';

class TwoDiceSpinnerPage extends StatefulWidget {
  const TwoDiceSpinnerPage({super.key});

  @override
  State<TwoDiceSpinnerPage> createState() => _TwoDiceSpinnerPageState();
}

class _TwoDiceSpinnerPageState extends State<TwoDiceSpinnerPage>
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
      curve: DiceConstants.spinCurve,
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

    cubit.startSpin();

    final durationMs =
        DiceConstants.baseSpinDuration.inMilliseconds +
        (cubit.state.extraSteps * DiceConstants.extraStepDurationMs);

    _controller.duration = Duration(milliseconds: durationMs);
    _controller.reset();

    int lastTick = 0;

    final ticker = Ticker((elapsed) {
      if (elapsed.inMilliseconds - lastTick >= 100) {
        lastTick = elapsed.inMilliseconds;
        cubit.updateFaces(); // 👈 الاتنين يتغيروا مع بعض
      }
    });

    ticker.start();
    await _controller.forward();

    ticker.stop();
    ticker.dispose();

    cubit.endSpin(); // 👈 الاتنين يقفوا مع بعض
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _spin,
          child: Column(
            children: [
              // 🔼 Dice 1
              Expanded(
                child: Center(
                  child: DiceFaceView(face: state.face1, rotation: _rotation),
                ),
              ),

              // 🔽 Dice 2
              Expanded(
                child: Center(
                  child: DiceFaceView(face: state.face2, rotation: _rotation),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
