import 'package:equatable/equatable.dart';

abstract class RecommendedTvShowEvent extends Equatable {
  const RecommendedTvShowEvent();
}

class RecommendedTvShowEventStarted extends RecommendedTvShowEvent {
  final int tvShowId;
  final String query;

  const RecommendedTvShowEventStarted(this.tvShowId, this.query);

  @override
  // List<Object> get props => [tvShowId, query];
  List<Object> get props => [];
}
