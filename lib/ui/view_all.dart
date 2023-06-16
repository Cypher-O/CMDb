import 'package:CMDb/bloc/moviebloc/movie_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/ui/discover_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tvshowbloc/tvshow_bloc_event.dart';

class ViewAllScreen extends StatelessWidget {
  final Widget itemWidget;
  final String title;
  final List<dynamic> itemList;

  const ViewAllScreen({
    Key key,
    this.itemWidget,
    this.title,
    this.itemList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Rendering ViewAllScreen');
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) =>
          MovieBloc()
            ..add(const MovieEventStarted(0, '')),
        ),
        BlocProvider<TvShowBloc>(
          create: (_) =>
          TvShowBloc()
            ..add(const TvShowEventStarted(0, '')),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('All $title'),
        ),
        body: ListView.builder(
          itemCount: itemList?.length ?? 0,
          // itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            if (itemWidget is MovieList) {
              return BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoaded) {
                    List<Movie> movieList = state.movieList;
                    Movie movie = movieList[index];
                    return MovieList(movie: movie);
                  }
                  else {
                    return const Center(); // Show a loading or error widget if needed
                  }
                },
              );
            } else if (itemWidget is TvShowList) {
              return BlocBuilder<TvShowBloc, TvShowState>(
                builder: (context, state) {
                  if (state is TvShowLoaded) {
                    List<TvShow> tvShows =
                        state.tvShowList;
                    // print(tvShows.length);
                          TvShow tvShow = tvShows[index];
                          return TvShowList(tvShow: tvShow);
                    // Pass the tvShowList to TvShowList widget
                  } else {
                    return const Center(); // Show a loading or error widget if needed
                  }
                },
              );
            } else {
              return const SizedBox(); // Return an empty widget if the itemWidget is neither MovieList nor TvShowList
            }
          },
        ),
      ),
    );
  }
}
