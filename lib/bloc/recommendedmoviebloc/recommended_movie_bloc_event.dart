import 'package:equatable/equatable.dart';

abstract class RecommendedMovieEvent extends Equatable {
  const RecommendedMovieEvent();
}

class RecommendedMovieEventStarted extends RecommendedMovieEvent {
  final int movieId;
  final String query;

  const RecommendedMovieEventStarted(this.movieId, this.query);

  @override
  // List<Object> get props => [tvShowId, query];
  List<Object> get props => [];
}
