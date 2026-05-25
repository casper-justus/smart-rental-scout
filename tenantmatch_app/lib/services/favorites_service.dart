import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'tmFavorites';
  List<String> _favorites = [];
  late SharedPreferences _prefs;

  List<String> get favorites => List.unmodifiable(_favorites);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _favorites = _prefs.getStringList(_key) ?? [];
  }

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> toggle(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    await _prefs.setStringList(_key, _favorites);
  }

  Future<void> add(String id) async {
    if (!_favorites.contains(id)) {
      _favorites.add(id);
      await _prefs.setStringList(_key, _favorites);
    }
  }

  Future<void> remove(String id) async {
    _favorites.remove(id);
    await _prefs.setStringList(_key, _favorites);
  }
}
