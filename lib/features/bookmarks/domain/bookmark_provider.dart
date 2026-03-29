import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkNotifier extends AsyncNotifier<List<String>> {
  static const _key = 'bookmarked_monuments';

  @override
  Future<List<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleBookmark(String monumentId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentState = state.value ?? [];
    List<String> newState;
    if (currentState.contains(monumentId)) {
      newState = currentState.where((id) => id != monumentId).toList();
    } else {
      newState = [...currentState, monumentId];
    }
    state = AsyncValue.data(newState);
    await prefs.setStringList(_key, newState);
  }
}

final bookmarkProvider = AsyncNotifierProvider<BookmarkNotifier, List<String>>(() {
  return BookmarkNotifier();
});
