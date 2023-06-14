
import 'package:CMDb/model/tvshow.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedTvShowState extends Equatable {
  const RecommendedTvShowState();

  @override
  List<Object> get props => [];
}

class RecommendedTvShowLoading extends RecommendedTvShowState {}

class RecommendedTvShowLoaded extends RecommendedTvShowState {
  final List<TvShow> recommendedTvShowList;

  const RecommendedTvShowLoaded(this.recommendedTvShowList);

  @override
  List<Object> get props => [recommendedTvShowList];
}

class RecommendedTvShowError extends RecommendedTvShowState {}