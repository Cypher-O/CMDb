import 'package:CMDb/bloc/borntodaybloc/born_today_event.dart';
import 'package:CMDb/bloc/borntodaybloc/born_today_state.dart';
import 'package:CMDb/model/born_today.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BornTodayBloc extends Bloc<BornTodayEvent, BornTodayState> {
  BornTodayBloc() : super(BornTodayLoading());

  @override
  Stream<BornTodayState> mapEventToState(BornTodayEvent event) async* {
    if (event is BornTodayEventStarted) {
      yield* _mapMovieEventStartedToState();
    }
  }

  Stream<BornTodayState> _mapMovieEventStartedToState() async* {
    final apiRepository = ApiService();
    // yield BornTodayLoading();
    try {
      final List<BornToday> bornToday = await apiRepository.getBornToday();
      yield BornTodayLoaded(bornToday);
    } catch (_) {
      yield BornTodayError();
    }
  }
}