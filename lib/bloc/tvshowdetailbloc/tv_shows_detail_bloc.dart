import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/bloc/tvshowdetailbloc/tv_shows_detail_event.dart';
import 'package:CMDb/bloc/tvshowdetailbloc/tv_shows_detail_state.dart';
import 'package:CMDb/service/api_service.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  TvShowDetailBloc() : super(TvShowDetailLoading());

  @override
  Stream<TvShowDetailState> mapEventToState(TvShowDetailEvent event) async* {
    if (event is TvShowDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

  Stream<TvShowDetailState> _mapMovieEventStartedToState(int id) async* {
    final apiRepository = ApiService();
    yield TvShowDetailLoading();
    try {
      final tvShowDetail = await apiRepository.getTvShowDetail(id);

      yield TvShowDetailLoaded(tvShowDetail);
    } on Exception catch (e) {
      print(e);
      yield TvShowDetailError();
    }
  }
}
