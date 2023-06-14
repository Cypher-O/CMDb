import 'package:equatable/equatable.dart';

abstract class TvShowDetailEvent extends Equatable {
  const TvShowDetailEvent();
}

class TvShowDetailEventStated extends TvShowDetailEvent {
  final int id;
  final int seasonNumber;

  TvShowDetailEventStated(this.id, this.seasonNumber);

  @override
  List<Object> get props => [id, seasonNumber];
}
