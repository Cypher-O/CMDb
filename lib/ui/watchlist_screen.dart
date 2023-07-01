import 'package:CMDb/widgets/tvshow_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/widgets/movie_list_widget.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistModel>(
      builder: (context, watchlistModel, child) {
        List<Movie> movieWatchlist = watchlistModel.movieWatchlist;
        List<TvShow> tvShowWatchlist = watchlistModel.tvShowWatchlist;

        return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.bookmark_added_rounded),
            title: Text("Favorites"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns as desired
                crossAxisSpacing: 10.0, // Adjust the spacing between columns
                mainAxisSpacing: 12.0, // Adjust the spacing between rows
                childAspectRatio: 0.5,
              ),
              itemCount: movieWatchlist.length + tvShowWatchlist.length,
              itemBuilder: (context, index) {
                if (index < movieWatchlist.length) {
                  // Render movie item
                  Movie movie = movieWatchlist[index];
                  return MovieListWidget(movieList: [movie]);
                } else {
                  // Render TV show item
                  int tvShowIndex = index - movieWatchlist.length;
                  TvShow tvShow = tvShowWatchlist[tvShowIndex];
                  // Render TV show item widget here
                  return TvShowListWidget(tvShows: [tvShow]);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
