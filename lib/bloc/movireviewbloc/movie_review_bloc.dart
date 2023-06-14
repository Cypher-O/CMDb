import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc_event.dart';
import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc_state.dart';
import 'package:CMDb/model/review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/service/api_service.dart';


class MovieReviewBloc extends Bloc<MovieReviewEvent, MovieReviewState> {
  MovieReviewBloc() : super(MovieReviewLoading());

  @override
  Stream<MovieReviewState> mapEventToState(MovieReviewEvent event) async* {
    if (event is MovieReviewEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieReviewState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield MovieReviewLoading();
    try {
      List<Review> movieReviewList;
      if (movieId == 0) {
        movieReviewList = await service.getAllMovieReviews();
      } else {
        movieReviewList = await service.getMovieReviews(movieId);
        // print('Reviews: $movieReviewList');
      }

      yield MovieReviewLoaded(movieReviewList);
    } on Exception catch (e) {
      print(e);
      yield MovieReviewError();
    }
  }
}

