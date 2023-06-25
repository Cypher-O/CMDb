import 'package:CMDb/model/born_today.dart';
import 'package:equatable/equatable.dart';

abstract class BornTodayState extends Equatable {
  const BornTodayState();

  @override
  List<Object> get props => [];
}

class BornTodayLoading extends BornTodayState {}

class BornTodayError extends BornTodayState {}

class BornTodayLoaded extends BornTodayState {
  final List<BornToday> bornTodayList;
  const BornTodayLoaded(this.bornTodayList);

  @override
  List<Object> get props => [bornTodayList];
}

