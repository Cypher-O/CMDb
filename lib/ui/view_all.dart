import 'dart:io';

import 'package:CMDb/bloc/moviebloc/movie_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/ui/discover_screen.dart';
import 'package:CMDb/ui/rating_widget.dart';
import 'package:CMDb/ui/tv_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../bloc/tvshowbloc/tvshow_bloc_event.dart';

//
// class ViewAllScreen extends StatelessWidget {
//   final List<dynamic> itemList;
//   final String title;
//
//   const ViewAllScreen({Key key, this.itemList, this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All $title'),
//       ),
//       body: ListView.builder(
//         itemCount: itemList.length,
//         itemBuilder: (context, index) {
//           dynamic item = itemList[index];
//           return ListTile(
//             title: Text(item.title),
//             // Customize the list item as per your requirements
//           );
//         },
//       ),
//     );
//   }
// }

// class ViewAllScreen extends StatelessWidget {
//   final List<dynamic> itemList;
//   final String title;
//   final Widget itemWidget;
//
//   const ViewAllScreen({
//     Key key,
//     this.itemList,
//     this.title,
//     this.itemWidget,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All $title'),
//       ),
//       body: ListView.builder(
//         itemCount: itemList.length,
//         itemBuilder: (context, index) {
//           dynamic item = itemList[index];
//           return itemWidget; // Use the passed itemWidget here
//         },
//       ),
//     );
//   }
// }
//

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

// class ViewAllScreen extends StatelessWidget {
//   final Widget itemWidget;
//   final String title;
//   final List<dynamic> itemList;
//
//   const ViewAllScreen({
//     Key key,
//     this.itemWidget,
//     this.title,
//     this.itemList,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All $title'),
//       ),
//       // body: itemWidget,
//       body: ListView.builder(
//         itemCount: itemList.length,
//         itemBuilder: (BuildContext context, int index) {
//           if (itemWidget is MovieList) {
//             return BlocBuilder<MovieBloc, MovieState>(
//               builder: (context, state) {
//                 if (state is MovieLoaded) {
//                   List<Movie> movieList = state.movieList;
//                   return itemWidget; // Pass the movieList to MovieList widget
//                 } else {
//                   return const Center(); // Show a loading or error widget if needed
//                 }
//               },
//             );
//           } else if (itemWidget is TvShowList) {
//             return BlocBuilder<TvShowBloc, TvShowState>(
//               builder: (context, state) {
//                 if (state is TvShowLoaded) {
//                   List<TvShow> tvShowList = state.tvShowList;
//                   return itemWidget; // Pass the tvShowList to TvShowList widget
//                 } else {
//                   return const Center(); // Show a loading or error widget if needed
//                 }
//               },
//             );
//           } else {
//             return const SizedBox(); // Return an empty widget if the itemWidget is neither MovieList nor TvShowList
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class ViewAllScreen extends StatelessWidget {
//   final List<dynamic> itemList;
//   final String title;
//
//   const ViewAllScreen({Key key, this.itemList, this.title}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('All $title'),
//       ),
//       body: ListView.builder(
//         itemCount: itemList.length,
//         itemBuilder: (context, index) {
//           dynamic item = itemList[index];
//           return ListTile(
//             title: Text(item.title),
//             // Customize the list item as per your requirements
//           );
//         },
//       ),
//     );
//   }
// }
