import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local bookmark persistence service.
///
/// Uses SharedPreferences to store bookmarked verse IDs.
/// Provides a [ValueNotifier] so widgets can reactively update.
class BookmarkService extends ChangeNotifier {
  static const String _key = 'bookmarked_verse_ids';
  final Set<String> _bookmarkedIds = {};
  bool _initialized = false;

  Set<String> get bookmarkedIds => Set.unmodifiable(_bookmarkedIds);
  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    _bookmarkedIds.addAll(saved);
    _initialized = true;
    notifyListeners();
  }

  bool isBookmarked(String verseId) => _bookmarkedIds.contains(verseId);

  Future<void> toggle(String verseId) async {
    if (_bookmarkedIds.contains(verseId)) {
      _bookmarkedIds.remove(verseId);
    } else {
      _bookmarkedIds.add(verseId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _bookmarkedIds.toList());
  }
}
