// ignore_for_file: invalid_use_of_protected_member
import 'dart:math';

import 'package:dice/features/normal_dice/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/dice_constants.dart';

class AnimatedDiceView extends StatefulWidget {
  final int face;
  final int spinToken; // 👈 يتغير مع كل Roll
  final double size;

  const AnimatedDiceView({
    super.key,
    required this.face,
    required this.spinToken,
    this.size = 72,
  });

  @override
  State<AnimatedDiceView> createState() => _AnimatedDiceViewState();
}

class _AnimatedDiceViewState extends State<AnimatedDiceView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  int _tempFace = 1;
  bool _spinning = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _tempFace = widget.face <= 0 ? 1 : widget.face;

    _controller = AnimationController(
      vsync: this,
      duration: DiceConstants.baseSpinDuration,
    );

    _rotation = CurvedAnimation(
      parent: _controller,
      curve: DiceConstants.spinCurve,
    );

    // ✅ مهم: يبدأ اللف حتى في أول Build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startSpin();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedDiceView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ كل مرة spinToken يتغير، نلف تاني
    if (widget.spinToken != oldWidget.spinToken) {
      _startSpin();
    }
  }

  Future<void> _startSpin() async {
    if (_spinning) return;
    _spinning = true;

    _controller.reset();

    int lastTick = 0;
    final ticker = Ticker((elapsed) {
      if (elapsed.inMilliseconds - lastTick >= 100) {
        lastTick = elapsed.inMilliseconds;
        setState(() => _tempFace = _random.nextInt(6) + 1);
      }
    });

    ticker.start();
    await _controller.forward();

    ticker.stop();
    ticker.dispose();

    if (!mounted) return;

    setState(() {
      _tempFace = widget.face <= 0 ? 1 : widget.face;
      _spinning = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DiceFaceView.pure(
      face: _tempFace,
      rotation: _rotation,
      size: widget.size.w,
    );
  }
}
