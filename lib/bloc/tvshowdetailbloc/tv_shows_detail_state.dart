import 'package:equatable/equatable.dart';
import 'package:CMDb/model/tvshow_detail.dart';

abstract class TvShowDetailState extends Equatable {
  const TvShowDetailState();

  @override
  List<Object> get props => [];
}

class TvShowDetailLoading extends TvShowDetailState {}

class TvShowDetailError extends TvShowDetailState {}

class TvShowDetailLoaded extends TvShowDetailState {
  final TvShowDetail detail;
  const TvShowDetailLoaded(this.detail);

  @override
  List<Object> get props => [detail];
}
