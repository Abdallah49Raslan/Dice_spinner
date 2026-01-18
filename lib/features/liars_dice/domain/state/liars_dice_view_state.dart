class LiarsDiceViewState {
  final bool showDice;
  final int spinToken;
  final bool diceAnimating;

  final bool rollLocked;
  final bool awaitingNext;
  final int? pendingNextIndex;
  final bool pendingAllRolled;

  const LiarsDiceViewState({
    this.showDice = false,
    this.spinToken = 0,
    this.diceAnimating = false,
    this.rollLocked = false,
    this.awaitingNext = false,
    this.pendingNextIndex,
    this.pendingAllRolled = false,
  });

  static const _sentinel = Object();

  LiarsDiceViewState copyWith({
    bool? showDice,
    int? spinToken,
    bool? diceAnimating,
    bool? rollLocked,
    bool? awaitingNext,
    Object? pendingNextIndex = _sentinel,
    bool? pendingAllRolled,
  }) {
    return LiarsDiceViewState(
      showDice: showDice ?? this.showDice,
      spinToken: spinToken ?? this.spinToken,
      diceAnimating: diceAnimating ?? this.diceAnimating,
      rollLocked: rollLocked ?? this.rollLocked,
      awaitingNext: awaitingNext ?? this.awaitingNext,
      pendingNextIndex: identical(pendingNextIndex, _sentinel)
          ? this.pendingNextIndex
          : pendingNextIndex as int?,
      pendingAllRolled: pendingAllRolled ?? this.pendingAllRolled,
    );
  }
}
