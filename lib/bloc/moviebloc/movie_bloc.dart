import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/service/api_service.dart';

// class MovieBloc extends Bloc<MovieEvent, MovieState> {
//   MovieBloc() : super(MovieLoading()) {
//     on<MovieEventStarted>((event, emit) async *{
//       yield* _mapMovieEventStateToState(event.movieId, event.query);
//     });
//   }
//
//   Stream<MovieState> _mapMovieEventStateToState(
//       int movieId, String query) async* {
//     final service = ApiService();
//     yield MovieLoading();
//     try {
//       late List<Movie> movieList;
//       if (movieId == 0) {
//         movieList = await service.getNowPlayingMovie();
//       }
//       else {
//         //print(movieId);
//         movieList = await service.getMovieByGenre(movieId);
//       }
//
//       yield MovieLoaded(movieList);
//     } on Exception catch (e) {
//       print(e);
//       yield MovieError();
//     }
//   }
//
//   @override
//   Stream<MovieState> mapEventToState(MovieEvent event) async* {
//     // No need to implement this method anymore since we're using `on<MovieEventStarted>`
//     // as a handler for the MovieEventStarted event
//   }
// }


class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield MovieLoading();
    try {
      List<Movie> movieList;
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
      } else {
        //print(movieId);
        movieList = await service.getMovieByGenre(movieId);
      }

      yield MovieLoaded(movieList);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}

