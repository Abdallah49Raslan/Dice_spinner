class DiceState {
  final bool isSpinning;
  final int face1;
  final int face2;
  final int extraSteps;

  const DiceState({
    required this.isSpinning,
    required this.face1,
    required this.face2,
    required this.extraSteps,
  });

  const DiceState.initial()
      : isSpinning = false,
        face1 = 1,
        face2 = 1,
        extraSteps = 0;

  DiceState copyWith({
    bool? isSpinning,
    int? face1,
    int? face2,
    int? extraSteps,
  }) {
    return DiceState(
      isSpinning: isSpinning ?? this.isSpinning,
      face1: face1 ?? this.face1,
      face2: face2 ?? this.face2,
      extraSteps: extraSteps ?? this.extraSteps,
    );
  }
}
