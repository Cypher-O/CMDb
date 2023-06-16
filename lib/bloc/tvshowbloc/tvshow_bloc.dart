import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_event.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_state.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/service/api_service.dart';

class TvShowBloc extends Bloc<TvShowEvent, TvShowState> {
  TvShowBloc() : super(TvShowLoading());

  @override
  Stream<TvShowState> mapEventToState(TvShowEvent event) async* {
    if (event is TvShowEventStarted) {
      yield* _mapMovieEventStateToState(event.tvShowId, event.query);
    }
  }

  Stream<TvShowState> _mapMovieEventStateToState(
      int tvShowId, String query) async* {
    final service = ApiService();
    yield TvShowLoading();
    try {
      List<TvShow> tvShowList;
      // List<TvShow> similarTvShowList;
      if (tvShowId == 0) {
        tvShowList = await service.getPopularTvShow();
        // similarTvShowList = await service.getSimilarTvShow(seriesId);
      }
      yield TvShowLoaded(tvShowList);
      // yield TvShowLoaded(tvShowList, similarTvShowList);
    } on Exception catch (e) {
      print(e);
      yield TvShowError();
    }
  }
}

