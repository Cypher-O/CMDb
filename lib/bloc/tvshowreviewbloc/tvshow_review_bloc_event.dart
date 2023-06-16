import 'package:equatable/equatable.dart';

abstract class TvShowReviewEvent extends Equatable {
  const TvShowReviewEvent();
}

class TvShowReviewEventStarted extends TvShowReviewEvent {
  final int tvShowId;
  final String query;

  const TvShowReviewEventStarted(this.tvShowId, this.query);

  @override
  List<Object> get props => [];
}
