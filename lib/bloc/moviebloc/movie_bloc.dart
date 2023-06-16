import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/service/api_service.dart';

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
      List<Movie> topRatedMovieList;
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
        topRatedMovieList = await service.getTopRatedMovie();
      } else {
        //print(movieId);
        movieList = await service.getMovieByGenre(movieId);
      }

      yield MovieLoaded(movieList, topRatedMovieList);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}

