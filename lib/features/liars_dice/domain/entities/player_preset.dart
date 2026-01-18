class PlayerPreset {
  final String id;
  final String title;
  final List<String> players;
  final DateTime updatedAt;

  const PlayerPreset({
    required this.id,
    required this.title,
    required this.players,
    required this.updatedAt,
  });

  PlayerPreset copyWith({
    String? id,
    String? title,
    List<String>? players,
    DateTime? updatedAt,
  }) {
    return PlayerPreset(
      id: id ?? this.id,
      title: title ?? this.title,
      players: players ?? this.players,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
