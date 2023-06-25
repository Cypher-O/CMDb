import 'package:equatable/equatable.dart';

abstract class BornTodayEvent extends Equatable {
  const BornTodayEvent();
}

class BornTodayEventStarted extends BornTodayEvent {
  @override
  List<Object> get props => [];
}
