import 'package:equatable/equatable.dart';

abstract class TvShowDetailEvent extends Equatable {
  const TvShowDetailEvent();
}

class TvShowDetailEventStated extends TvShowDetailEvent {
  final int id;

  TvShowDetailEventStated(this.id);

  @override
  List<Object> get props => [];
}
