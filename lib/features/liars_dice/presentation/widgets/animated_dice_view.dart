// ignore_for_file: invalid_use_of_protected_member

import 'package:dice/features/normal_dice/presentation/widgets/dice_face_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../../core/constants/dice_constants.dart';

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

  /// ✅ جديد: Callback لما السبين يبدأ/يخلص (عشان تمنع Next أثناء اللف)
  final VoidCallback? onSpinStart;
  final VoidCallback? onSpinEnd;

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

    // ✅ جديد
    this.onSpinStart,
    this.onSpinEnd,
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

  // ✅ جديد: نخلي الـ ticker مرجّع عشان نوقفه في dispose
  Ticker? _ticker;

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
    if (!mounted) return;

    _spinning = true;
    widget.onSpinStart?.call(); // ✅ جديد

    _controller.reset();

    int lastTick = 0;

    // ✅ جديد: خزّن الـ ticker ووقف أي قديم
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;

    _ticker = Ticker((elapsed) {
      if (!mounted) return;

      if (elapsed.inMilliseconds - lastTick >= 100) {
        lastTick = elapsed.inMilliseconds;

        final next = _sanitizeFace(widget.tickFacePicker());

        if (!mounted) return;
        setState(() => _tempFace = next);

        widget.onTickFace?.call(next);
      }
    });

    _ticker!.start();

    // ✅ forward ممكن يرمي TickerCanceled لو اتعمل dispose أثناء الأنيميشن
    try {
      await _controller.forward();
    } on TickerCanceled {
      // dispose حصل أثناء الأنيميشن
      return;
    }

    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;

    if (!mounted) return;

    final finalFace = _sanitizeFace(
      widget.finishFacePicker?.call() ?? widget.face,
    );

    if (!mounted) return;
    setState(() {
      _tempFace = finalFace;
      _spinning = false;
    });

    widget.onFinishFace?.call(finalFace);
    widget.onSpinEnd?.call(); // ✅ جديد
  }

  @override
  void dispose() {
    // ✅ مهم جدًا: وقف الـ ticker قبل dispose
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diceWidget = DiceFaceView(
      face: _tempFace,
      rotation: _rotation,
      size: widget.size,
      showBackground: widget.showBackground,
      showLabel: widget.showLabel,
    );

    if (!widget.enableTapSpin) return diceWidget;

    return GestureDetector(onTap: _startSpin, child: diceWidget);
  }
}
