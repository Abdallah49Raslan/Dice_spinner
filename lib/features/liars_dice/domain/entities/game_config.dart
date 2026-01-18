
enum GameLevel { easy, medium, hard }

class GameConfig {
  final int dicePerPlayer;
  final bool onesAreWild;

  const GameConfig({
    required this.dicePerPlayer,
    required this.onesAreWild,
  });

  factory GameConfig.fromLevel(GameLevel level) {
    switch (level) {
      case GameLevel.easy:
        return const GameConfig(
          dicePerPlayer: 1,
          onesAreWild: false,
        );

      case GameLevel.medium:
        return const GameConfig(
          dicePerPlayer: 3,
          onesAreWild: false,
        );

      case GameLevel.hard:
        return const GameConfig(
          dicePerPlayer: 5,
          onesAreWild: true,
        );
    }
  }
}
