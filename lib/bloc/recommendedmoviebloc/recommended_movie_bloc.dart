import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc_event.dart';
import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc_state.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedMovieBloc extends Bloc<RecommendedMovieEvent, RecommendedMovieState> {
  RecommendedMovieBloc() : super(RecommendedMovieLoading());

  @override
  Stream<RecommendedMovieState> mapEventToState(RecommendedMovieEvent event) async* {
    if (event is RecommendedMovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<RecommendedMovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield RecommendedMovieLoading();
    try {
      List<Movie> recommendedMovieList;
      if (movieId != 0) {
        recommendedMovieList = await service.getMovieRecommendations(movieId);
      }
      yield RecommendedMovieLoaded(recommendedMovieList);
    } on Exception catch (e) {
      print(e);
      yield RecommendedMovieError();
    }
  }
}