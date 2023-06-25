import 'dart:convert';

import 'package:CMDb/model/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistStorage {
  static const String _watchlistKey = 'watchlist';

  Future<List<Movie>> getWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlistJson = prefs.getStringList(_watchlistKey) ?? [];
    return watchlistJson.map((json) => Movie.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveWatchlist(List<Movie> watchlist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlistJson = watchlist.map((movie) => jsonEncode(movie.toJson())).toList();
    prefs.setStringList(_watchlistKey, watchlistJson);
  }
}

