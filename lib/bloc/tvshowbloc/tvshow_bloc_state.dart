import 'package:equatable/equatable.dart';
import 'package:CMDb/model/tvshow.dart';

abstract class TvShowState extends Equatable {
  const TvShowState();

  @override
  List<Object> get props => [];
}

class TvShowLoading extends TvShowState {}

class TvShowLoaded extends TvShowState {
  final List<TvShow> tvShowList;
  // final List<TvShow> similarTvShowList;

  const TvShowLoaded(this.tvShowList);

  @override
  List<Object> get props => [tvShowList];
  // List<Object> get props => [tvShowList, similarTvShowList];
}

class TvShowError extends TvShowState {}
