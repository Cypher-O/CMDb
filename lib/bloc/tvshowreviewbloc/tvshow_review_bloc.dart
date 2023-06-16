import 'package:CMDb/bloc/tvshowreviewbloc/tvshow_review_bloc_event.dart';
import 'package:CMDb/bloc/tvshowreviewbloc/tvshow_review_bloc_state.dart';
import 'package:CMDb/model/review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/service/api_service.dart';

class TvShowReviewBloc extends Bloc<TvShowReviewEvent, TvShowReviewState> {
  TvShowReviewBloc() : super(TvShowReviewLoading());

  @override
  Stream<TvShowReviewState> mapEventToState(TvShowReviewEvent event) async* {
    if (event is TvShowReviewEventStarted) {
      yield* _mapMovieEventStateToState(event.tvShowId, event.query);
    }
  }

  Stream<TvShowReviewState> _mapMovieEventStateToState(
      int tvShowId, String query) async* {
    final service = ApiService();
    yield TvShowReviewLoading();
    try {
      List<Review> tvShowReviewList;
      // List<TvShow> similarTvShowList;
      if (tvShowId == 0) {
        tvShowReviewList = await service.getAllTvShowsReviews();
        // similarTvShowList = await service.getSimilarTvShow(seriesId);
      }else{
        tvShowReviewList = await service.getTvShowsReviews(tvShowId);
        // print('Reviews: $tvShowReviewList');
      }

      yield TvShowReviewLoaded(tvShowReviewList);
      // yield TvShowLoaded(tvShowList, similarTvShowList);
    } on Exception catch (e) {
      print(e);
      yield TvShowReviewError();
    }
  }
}

