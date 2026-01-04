class DiceState {
  final int face;
  final bool isSpinning;
  final int extraSteps;

  const DiceState({
    required this.face,
    required this.isSpinning,
    required this.extraSteps,
  });

  const DiceState.initial()
      : face = 1,
        isSpinning = false,
        extraSteps = 0;

  DiceState copyWith({
    int? face,
    bool? isSpinning,
    int? extraSteps,
  }) {
    return DiceState(
      face: face ?? this.face,
      isSpinning: isSpinning ?? this.isSpinning,
      extraSteps: extraSteps ?? this.extraSteps,
    );
  }
}
