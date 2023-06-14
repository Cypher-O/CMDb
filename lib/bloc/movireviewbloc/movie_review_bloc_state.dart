import 'package:CMDb/model/review.dart';
import 'package:equatable/equatable.dart';

abstract class MovieReviewState extends Equatable {
  const MovieReviewState();

  @override
  List<Object> get props => [];
}

class MovieReviewLoading extends MovieReviewState {}

class MovieReviewLoaded extends MovieReviewState {
  final List<Review> movieReviewList;

  const MovieReviewLoaded(this.movieReviewList);

  @override
  List<Object> get props {
    return [movieReviewList];
  }
}

class MovieReviewError extends MovieReviewState {}
