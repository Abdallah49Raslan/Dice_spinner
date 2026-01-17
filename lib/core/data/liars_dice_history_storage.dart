import 'package:hive/hive.dart';

class LiarsDiceHistoryStorage {
  static const String boxName = 'liars_dice_history_box';
  static const String key = 'presets';

  Future<Box> _open() async => Hive.isBoxOpen(boxName)
      ? Hive.box(boxName)
      : await Hive.openBox(boxName);

  Future<List<List<String>>> load() async {
    final box = await _open();
    final raw = box.get(key, defaultValue: <dynamic>[]);
    final list = (raw as List).map((e) {
      final names = (e as List).map((x) => x.toString()).toList();
      return names;
    }).toList();
    return list;
  }

  Future<void> savePreset(List<String> players) async {
    final box = await _open();
    final presets = await load();

    // ✅ نظافة: شيل الفاضي + trim
    final cleaned = players.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (cleaned.length < 2) return;

    // ✅ منع تكرار نفس القائمة
    presets.removeWhere((p) => _sameList(p, cleaned));

    // ✅ حطها أول واحدة
    presets.insert(0, cleaned);

    // ✅ حد أقصى (اختياري)
    const maxItems = 15;
    final limited = presets.take(maxItems).toList();

    await box.put(key, limited);
  }

  Future<void> deleteAt(int index) async {
    final box = await _open();
    final presets = await load();
    if (index < 0 || index >= presets.length) return;
    presets.removeAt(index);
    await box.put(key, presets);
  }

  Future<void> clearAll() async {
    final box = await _open();
    await box.put(key, <dynamic>[]);
  }

  bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].trim() != b[i].trim()) return false;
    }
    return true;
  }
}
