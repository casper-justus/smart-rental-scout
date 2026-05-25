import 'package:shared_preferences/shared_preferences.dart';

class FormDataService {
  static const _key = 'tmFormData';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Map<String, String> getData() {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    try {
      return Map<String, String>.from(
        raw.split('&').fold<Map<String, String>>({}, (map, pair) {
          final parts = pair.split('=');
          if (parts.length == 2) map[parts[0]] = parts[1];
          return map;
        }),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> save(Map<String, String> data) async {
    final encoded =
        data.entries.map((e) => '${e.key}=${e.value}').join('&');
    await _prefs.setString(_key, encoded);
  }

  Future<void> saveField(String key, String value) async {
    final data = getData();
    data[key] = value;
    await save(data);
  }
}
