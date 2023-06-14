import 'package:CMDb/bloc/similarmoviebloc/similar_movie_bloc_event.dart';
import 'package:CMDb/bloc/similarmoviebloc/similar_movie_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/service/api_service.dart';

class SimilarMovieBloc extends Bloc<SimilarMovieEvent, SimilarMovieState> {
  SimilarMovieBloc() : super(SimilarMovieLoading());

  @override
  Stream<SimilarMovieState> mapEventToState(SimilarMovieEvent event) async* {
    if (event is SimilarMovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<SimilarMovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield SimilarMovieLoading();
    try {
      List<Movie> similarMovieList;
      if (movieId != 0) {
        // print('Fetching similar TV shows for seriesId: $tvShowId');
        similarMovieList = await service.getSimilarMovies(movieId);
        // print('Similar TV Shows retrieved: $similarTvShowList');
      }
      yield SimilarMovieLoaded(similarMovieList);
    } on Exception catch (e) {
      print(e);
      yield SimilarMovieError();
    }
  }
}

