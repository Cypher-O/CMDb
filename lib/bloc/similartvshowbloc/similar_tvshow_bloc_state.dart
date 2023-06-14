import 'package:equatable/equatable.dart';
import 'package:CMDb/model/tvshow.dart';

abstract class SimilarTvShowState extends Equatable {
  const SimilarTvShowState();

  @override
  List<Object> get props => [];
}

class SimilarTvShowLoading extends SimilarTvShowState {}

class SimilarTvShowLoaded extends SimilarTvShowState {
  final List<TvShow> similarTvShowList;

  const SimilarTvShowLoaded(this.similarTvShowList);

  @override
  List<Object> get props => [similarTvShowList];
}

class SimilarTvShowError extends SimilarTvShowState {}
