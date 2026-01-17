import 'package:dice/features/liars_dice/Pages/setup_page/cubit/setup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dice/core/data/liars_dice_history_storage.dart';

typedef DefaultNameBuilder = String Function(int index); // index: 0-based

class LiarsDiceSetupCubit extends Cubit<LiarsDiceSetupState> {
  final LiarsDiceHistoryStorage _history;

  LiarsDiceSetupCubit(this._history)
      : super(
          LiarsDiceSetupState.initial(
            initialNames: const ['Player 1', 'Player 2'], // placeholder
          ),
        );

  Future<void> init({
    required int initialCount,
    required DefaultNameBuilder defaultName,
  }) async {
    final names = List.generate(initialCount, (i) => defaultName(i));
    emit(state.copyWith(names: names, loadingPresets: true));

    final presets = await _history.load();
    emit(state.copyWith(presets: presets, loadingPresets: false));
  }

  void setPlayersCount(int count, {required DefaultNameBuilder defaultName}) {
    if (count < 2) count = 2;
    if (count > 6) count = 6;

    final old = state.names;
    final next = List<String>.generate(count, (i) {
      if (i < old.length) {
        final v = old[i].trim();
        return v.isEmpty ? defaultName(i) : v;
      }
      return defaultName(i);
    });

    emit(state.copyWith(names: next));
  }

  void setName(int index, String value) {
    if (index < 0 || index >= state.names.length) return;
    final next = [...state.names];
    next[index] = value;
    emit(state.copyWith(names: next));
  }

  void applyPreset(List<String> players, {required DefaultNameBuilder defaultName}) {
    if (players.length < 2) return;

    final trimmed = players.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (trimmed.length < 2) return;

    final count = trimmed.length.clamp(2, 6);
    final next = List<String>.generate(count, (i) {
      if (i < trimmed.length) return trimmed[i];
      return defaultName(i);
    });

    emit(state.copyWith(names: next));
  }

  Future<void> saveCurrentPreset() async {
    final players = state.names.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (players.length < 2) return;

    await _history.savePreset(players);
    final presets = await _history.load();
    emit(state.copyWith(presets: presets));
  }

  Future<void> deletePreset(int index) async {
    await _history.deleteAt(index);
    final presets = await _history.load();
    emit(state.copyWith(presets: presets));
  }

  Future<void> clearAllPresets() async {
    await _history.clearAll();
    emit(state.copyWith(presets: const []));
  }
}
