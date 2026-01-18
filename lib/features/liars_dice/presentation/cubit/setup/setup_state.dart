import 'package:equatable/equatable.dart';

class LiarsDiceSetupState extends Equatable {
  final List<String> names; // length = playersCount
  final List<List<String>> presets;
  final bool loadingPresets;

  const LiarsDiceSetupState({
    required this.names,
    required this.presets,
    required this.loadingPresets,
  });

  int get playersCount => names.length;

  factory LiarsDiceSetupState.initial({
    required List<String> initialNames,
  }) {
    return LiarsDiceSetupState(
      names: initialNames,
      presets: const [],
      loadingPresets: true,
    );
  }

  LiarsDiceSetupState copyWith({
    List<String>? names,
    List<List<String>>? presets,
    bool? loadingPresets,
  }) {
    return LiarsDiceSetupState(
      names: names ?? this.names,
      presets: presets ?? this.presets,
      loadingPresets: loadingPresets ?? this.loadingPresets,
    );
  }

  @override
  List<Object?> get props => [names, presets, loadingPresets];
}
