import 'package:equatable/equatable.dart';

abstract class TvShowEvent extends Equatable {
  const TvShowEvent();
}

class TvShowEventStarted extends TvShowEvent {
  final int tvShowId;
  final String query;

  const TvShowEventStarted(this.tvShowId, this.query);

  @override
  List<Object> get props => [];
}
