class PlayerModel {
  final String name;
  final List<int> dice; // قيم النرد الحالية

  PlayerModel({
    required this.name,
    required this.dice,
  });

  PlayerModel copyWith({
    String? name,
    List<int>? dice,
  }) {
    return PlayerModel(
      name: name ?? this.name,
      dice: dice ?? this.dice,
    );
  }
}
