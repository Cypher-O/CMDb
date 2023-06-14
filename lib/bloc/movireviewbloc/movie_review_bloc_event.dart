import 'package:equatable/equatable.dart';

abstract class MovieReviewEvent extends Equatable {
  const MovieReviewEvent();
}

class MovieReviewEventStarted extends MovieReviewEvent {
  final int movieId;
  final String query;

  const MovieReviewEventStarted(this.movieId, this.query);

  @override
  List<Object> get props => [];
}
