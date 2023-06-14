import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc_event.dart';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc_state.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendedTvShowBloc extends Bloc<RecommendedTvShowEvent, RecommendedTvShowState> {
  RecommendedTvShowBloc() : super(RecommendedTvShowLoading());

  @override
  Stream<RecommendedTvShowState> mapEventToState(RecommendedTvShowEvent event) async* {
    if (event is RecommendedTvShowEventStarted) {
      yield* _mapMovieEventStateToState(event.tvShowId, event.query);
    }
  }

  Stream<RecommendedTvShowState> _mapMovieEventStateToState(
      int tvShowId, String query) async* {
    final service = ApiService();
    yield RecommendedTvShowLoading();
    try {
      List<TvShow> recommendedTvShowList;
      if (tvShowId != 0) {
        recommendedTvShowList = await service.getTvShowRecommendations(tvShowId);
      }
      yield RecommendedTvShowLoaded(recommendedTvShowList);
    } on Exception catch (e) {
      print(e);
      yield RecommendedTvShowError();
    }
  }
}