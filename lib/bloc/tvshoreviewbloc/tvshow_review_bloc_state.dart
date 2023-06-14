import 'package:CMDb/model/review.dart';
import 'package:equatable/equatable.dart';

abstract class TvShowReviewState extends Equatable {
  const TvShowReviewState();

  @override
  List<Object> get props => [];
}

class TvShowReviewLoading extends TvShowReviewState {}

class TvShowReviewLoaded extends TvShowReviewState {
  final List<Review> tvShowReviewList;
  // final List<TvShow> similarTvShowList;

  const TvShowReviewLoaded(this.tvShowReviewList);

  @override
  List<Object> get props => [tvShowReviewList];
  // List<Object> get props => [tvShowList, similarTvShowList];
}

class TvShowReviewError extends TvShowReviewState {}
