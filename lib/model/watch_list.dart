import 'package:CMDb/model/movie.dart';
import 'package:CMDb/ui/watch_list_storage.dart';
import 'package:flutter/material.dart';

class WatchlistModel extends ChangeNotifier {
  final WatchlistStorage storage = WatchlistStorage();
  List<Movie> watchlist = [];

  WatchlistModel() {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    watchlist = await storage.getWatchlist();
    notifyListeners();
  }

  void addToWatchlist(Movie movie) {
    watchlist.add(movie);
    _saveWatchlist();
    notifyListeners();
  }

  void removeFromWatchlist(Movie movie) {
    watchlist.remove(movie);
    _saveWatchlist();
    notifyListeners();
  }

  Future<void> _saveWatchlist() async {
    await storage.saveWatchlist(watchlist);
  }
}
