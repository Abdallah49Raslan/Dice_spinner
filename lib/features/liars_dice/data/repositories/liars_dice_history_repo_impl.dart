import 'package:dice/features/liars_dice/domain/repositories/liars_dice_history_repo.dart';

import '../datasources/local/liars_dice_history_storage.dart';

class LiarsDicePresetsRepoImpl implements LiarsDicePresetsRepo {
  final LiarsDiceHistoryStorage storage;

  LiarsDicePresetsRepoImpl(this.storage);

  @override
  Future<List<List<String>>> load() => storage.load();

  @override
  Future<void> savePreset(List<String> players) => storage.savePreset(players);

  @override
  Future<void> deleteAt(int index) => storage.deleteAt(index);

  @override
  Future<void> clearAll() => storage.clearAll();
}
