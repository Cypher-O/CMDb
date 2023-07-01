import 'package:CMDb/model/movie.dart';
import 'package:CMDb/ui/watch_list_storage.dart';
import 'package:flutter/material.dart';
import 'package:CMDb/model/tvshow.dart';

class WatchlistModel extends ChangeNotifier {
  final WatchlistStorage storage = WatchlistStorage();
  List<Movie> movieWatchlist = [];
  List<TvShow> tvShowWatchlist = [];

  WatchlistModel() {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final watchlistData = await storage.getWatchlist();

    for (final data in watchlistData) {
      if (data is Movie) {
        movieWatchlist.insert(0, data);
      } else if (data is TvShow) {
        tvShowWatchlist.insert(0, data);
      }
    }

    notifyListeners();
  }

  void addToWatchlist(Movie movie) {
    movieWatchlist.add(movie);
    _saveWatchlist();
    notifyListeners();
  }

  void addToWatchlistTvShow(TvShow tvShow) {
    tvShowWatchlist.add(tvShow);
    _saveWatchlist();
    notifyListeners();
  }

  void removeFromWatchlist(Movie movie) {
    movieWatchlist.remove(movie);
    _saveWatchlist();
    notifyListeners();
  }

  void removeFromWatchlistTvShow(TvShow tvShow) {
    tvShowWatchlist.remove(tvShow);
    _saveWatchlist();
    notifyListeners();
  }

  Future<void> _saveWatchlist() async {
    final combinedWatchlist = [...movieWatchlist, ...tvShowWatchlist];
    await storage.saveWatchlist(combinedWatchlist);
  }
}
