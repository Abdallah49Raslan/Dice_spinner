import 'package:dice/features/normal_dice/cubit/dice_cubit.dart';
import 'package:dice/features/normal_dice/cubit/dice_state.dart';
import 'package:dice/features/normal_dice/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/dice_constants.dart';

class DiceSpinnerPage extends StatefulWidget {
  const DiceSpinnerPage({super.key});

  @override
  State<DiceSpinnerPage> createState() => _DiceSpinnerPageState();
}

class _DiceSpinnerPageState extends State<DiceSpinnerPage> {
  static const int _initialPage = 300;

  late final PageController _controller;

  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _initialPage);

    _controller.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    final page = _controller.page;
    if (page == null) return;

    final index = page.round();
    if (index == _currentPage) return;

    _currentPage = index;
    context.read<DiceCubit>().onPageChanged(index);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPageScroll);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    final cubit = context.read<DiceCubit>();
    if (cubit.state.isSpinning) return;

    cubit.startSpin();

    final int targetPage = _currentPage + cubit.state.extraSteps;

    final int durationMs =
        DiceConstants.baseSpinDuration.inMilliseconds +
        (cubit.state.extraSteps * DiceConstants.extraStepDurationMs);

    await _controller.animateToPage(
      targetPage,
      duration: Duration(milliseconds: durationMs),
      curve: DiceConstants.spinCurve,
    );

    cubit.endSpin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceCubit, DiceState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _spin,
          child: PageView.builder(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return DiceFaceView(face: state.face);
            },
          ),
        );
      },
    );
  }
}
