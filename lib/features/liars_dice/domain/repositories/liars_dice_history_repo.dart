abstract class LiarsDicePresetsRepo {
  Future<List<List<String>>> load();
  Future<void> savePreset(List<String> players);
  Future<void> deleteAt(int index);
  Future<void> clearAll();
}
