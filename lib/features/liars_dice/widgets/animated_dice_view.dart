// ignore_for_file: invalid_use_of_protected_member

import 'package:dice/features/normal_dice/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/constants/dice_constants.dart';

typedef FacePicker = int Function();
typedef FaceChanged = void Function(int face);

class AnimatedDiceView extends StatefulWidget {
  final int face;
  final int? spinToken;
  final bool enableTapSpin;

  /// ✅ اختياري: لو null هنسيب DiceFaceView يحسب الحجم من DiceConstants
  final double? size;

  final bool showBackground;
  final bool showLabel;

  final FacePicker tickFacePicker;
  final FacePicker? finishFacePicker;

  final FaceChanged? onTickFace;
  final FaceChanged? onFinishFace;

  const AnimatedDiceView({
    super.key,
    required this.face,
    required this.tickFacePicker,
    this.finishFacePicker,
    this.onTickFace,
    this.onFinishFace,
    this.spinToken,
    this.enableTapSpin = false,
    this.size,
    this.showBackground = true,
    this.showLabel = false,
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

  @override
  void initState() {
    super.initState();

    _tempFace = _sanitizeFace(widget.face);

    _controller = AnimationController(
      vsync: this,
      duration: DiceConstants.baseSpinDuration,
    );

    _rotation = CurvedAnimation(
      parent: _controller,
      curve: DiceConstants.spinCurve,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.spinToken != null) _startSpin();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedDiceView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.spinToken != null && widget.spinToken != oldWidget.spinToken) {
      _startSpin();
      return;
    }

    _tempFace = _sanitizeFace(widget.face);
  }

  int _sanitizeFace(int face) {
    final f = face <= 0 ? DiceConstants.minFace : face;
    return f.clamp(DiceConstants.minFace, DiceConstants.maxFace);
  }

  Future<void> _startSpin() async {
    if (_spinning) return;
    _spinning = true;

    _controller.reset();

    int lastTick = 0;
    final ticker = Ticker((elapsed) {
      if (elapsed.inMilliseconds - lastTick >= 100) {
        lastTick = elapsed.inMilliseconds;
        final next = _sanitizeFace(widget.tickFacePicker());
        setState(() => _tempFace = next);
        widget.onTickFace?.call(next);
      }
    });

    ticker.start();
    await _controller.forward();

    ticker.stop();
    ticker.dispose();

    if (!mounted) return;

    final finalFace = _sanitizeFace(
      widget.finishFacePicker?.call() ?? widget.face,
    );

    setState(() {
      _tempFace = finalFace;
      _spinning = false;
    });

    widget.onFinishFace?.call(finalFace);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diceWidget = DiceFaceView(
      face: _tempFace,
      rotation: _rotation,
      size: widget.size, // ✅ null = DiceFaceView يحسب الحجم بنفسه
      showBackground: widget.showBackground,
      showLabel: widget.showLabel,
    );

    if (!widget.enableTapSpin) return diceWidget;

    return GestureDetector(onTap: _startSpin, child: diceWidget);
  }
}
