import 'dart:math';

import 'package:dice/features/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/dice_constants.dart';

class DiceSpinnerPage extends StatefulWidget {
  const DiceSpinnerPage({super.key});

  @override
  State<DiceSpinnerPage> createState() => _DiceSpinnerPageState();
}

class _DiceSpinnerPageState extends State<DiceSpinnerPage> {
  static const int _initialPage = 300;

  late final PageController _controller;
  final Random _rng = Random();

  bool _isSpinning = false;
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _initialPage);

    _controller.addListener(() {
      final page = _controller.page;
      if (page != null) {
        _currentPage = page.round();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _faceForIndex(int index) {
    return (index % DiceConstants.facesCount) + DiceConstants.minFace;
  }

  Future<void> _spin() async {
    if (_isSpinning) return;

    setState(() => _isSpinning = true);

    final int extraSteps =
        DiceConstants.minExtraSteps +
        _rng.nextInt(DiceConstants.maxExtraSteps - DiceConstants.minExtraSteps);

    final int targetPage = _currentPage + extraSteps;

    final int durationMs =
        DiceConstants.baseSpinDuration.inMilliseconds +
        (extraSteps * DiceConstants.extraStepDurationMs);

    await _controller.animateToPage(
      targetPage,
      duration: Duration(milliseconds: durationMs),
      curve: DiceConstants.spinCurve,
    );

    setState(() => _isSpinning = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _spin,
      child: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final face = _faceForIndex(index);

          return DiceFaceView(face: face);
        },
      ),
    );
  }
}
