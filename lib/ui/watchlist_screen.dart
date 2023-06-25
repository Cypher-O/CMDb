import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/watch_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistModel>(
      builder: (context, watchlistModel, child) {
        List<Movie> watchlist = watchlistModel.watchlist;

        return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.account_circle_outlined),
            title: Text("Favorites"),
          ),
          body: ListView.builder(
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              Movie movie = watchlist[index];
              return ListTile(
                title: Text(movie.title),
                // Other movie details
              );
            },
          ),
        );
      },
    );
  }
}
