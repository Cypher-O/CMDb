import 'package:equatable/equatable.dart';

abstract class SimilarMovieEvent extends Equatable {
  const SimilarMovieEvent();
}

class SimilarMovieEventStarted extends SimilarMovieEvent {
  final int movieId;
  final String query;

  const SimilarMovieEventStarted(this.movieId, this.query);

  @override
  // List<Object> get props => [tvShowId, query];
  List<Object> get props => [];
}
