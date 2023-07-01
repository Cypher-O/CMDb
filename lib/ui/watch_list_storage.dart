import 'dart:convert';

import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistStorage {
  static const String _watchlistKey = 'watchlist';

  Future<List<dynamic>> getWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlistJson = prefs.getStringList(_watchlistKey) ?? [];
    return watchlistJson.map((json) {
      final decoded = jsonDecode(json);
      if (decoded['type'] == 'movie') {
        return Movie.fromJson(decoded);
      } else if (decoded['type'] == 'tvshow') {
        return TvShow.fromJson(decoded);
      }
      return null;
    }).toList();
  }

  Future<void> saveWatchlist(List<dynamic> watchlist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> watchlistJson = watchlist.map((item) {
      if (item is Movie) {
        final json = item.toJson();
        json['type'] = 'movie';
        return jsonEncode(json);
      } else if (item is TvShow) {
        final json = item.toJson();
        json['type'] = 'tvshow';
        return jsonEncode(json);
      }
      return null;
    }).toList();
    prefs.setStringList(_watchlistKey, watchlistJson);
  }

  Future<void> clearWatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_watchlistKey);
  }
}