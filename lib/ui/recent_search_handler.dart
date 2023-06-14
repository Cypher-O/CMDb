import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchHandler {
  static const String _recentSearchKey = 'recent_searches';

  static Future<List<Map<String, dynamic>>> getRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = prefs.getStringList(_recentSearchKey) ?? [];
    return recentSearches.map((search) => jsonDecode(search)).toList().cast<Map<String, dynamic>>();
  }

  static Future<void> addRecentSearch(dynamic searchItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = prefs.getStringList(_recentSearchKey) ?? [];

    // Check if the search item already exists in the recent searches
    final existingSearch = recentSearches.firstWhere((search) => search == jsonEncode(searchItem), orElse: () => null);
    if (existingSearch != null) {
      // Search item already exists, remove it from the list
      recentSearches.remove(existingSearch);
    }

    recentSearches.add(jsonEncode(searchItem));
    await prefs.setStringList(_recentSearchKey, recentSearches);
  }


  static Future<void> addRecentSearchTile(dynamic searchTile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = prefs.getStringList(_recentSearchKey) ?? [];

    // Check if the search tile already exists in the recent searches
    final existingSearch = recentSearches.firstWhere((search) => search == jsonEncode(searchTile), orElse: () => null);
    if (existingSearch != null) {
      // Search tile already exists, remove it from the list
      recentSearches.remove(existingSearch);
    }

    recentSearches.add(jsonEncode(searchTile));
    await prefs.setStringList(_recentSearchKey, recentSearches);
  }

  static Future<void> clearRecentSearches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchKey);
  }

  static Future<void> removeRecentSearch(dynamic searchItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> recentSearches = prefs.getStringList(_recentSearchKey) ?? [];
    final searchItemJson = jsonEncode(searchItem);
    recentSearches.removeWhere((item) => item == searchItemJson);
    await prefs.setStringList(_recentSearchKey, recentSearches);
  }
}
