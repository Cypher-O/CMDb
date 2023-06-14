import 'package:CMDb/bloc/similartvshowbloc/similar_tvshow_bloc_event.dart';
import 'package:CMDb/bloc/similartvshowbloc/similar_tvshow_bloc_state.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/service/api_service.dart';

class SimilarTvShowBloc extends Bloc<SimilarTvShowEvent, SimilarTvShowState> {
  SimilarTvShowBloc() : super(SimilarTvShowLoading());

  @override
  Stream<SimilarTvShowState> mapEventToState(SimilarTvShowEvent event) async* {
    if (event is SimilarTvShowEventStarted) {
      yield* _mapMovieEventStateToState(event.tvShowId, event.query);
    }
  }

  Stream<SimilarTvShowState> _mapMovieEventStateToState(
      int tvShowId, String query) async* {
    final service = ApiService();
    yield SimilarTvShowLoading();
    try {
      List<TvShow> similarTvShowList;
      if (tvShowId != 0) {
        // print('Fetching similar TV shows for seriesId: $tvShowId');
        similarTvShowList = await service.getSimilarTvShow(tvShowId);
        // print('Similar TV Shows retrieved: $similarTvShowList');
      }
      yield SimilarTvShowLoaded(similarTvShowList);
    } on Exception catch (e) {
      print(e);
      yield SimilarTvShowError();
    }
  }
}

