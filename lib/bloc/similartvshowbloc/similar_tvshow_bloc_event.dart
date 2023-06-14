import 'package:equatable/equatable.dart';

abstract class SimilarTvShowEvent extends Equatable {
  const SimilarTvShowEvent();
}

class SimilarTvShowEventStarted extends SimilarTvShowEvent {
  final int tvShowId;
  final String query;

  const SimilarTvShowEventStarted(this.tvShowId, this.query);

  @override
  // List<Object> get props => [tvShowId, query];
  List<Object> get props => [];
}
