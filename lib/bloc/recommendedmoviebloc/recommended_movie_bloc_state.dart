
import 'package:CMDb/model/movie.dart';
import 'package:equatable/equatable.dart';

abstract class RecommendedMovieState extends Equatable {
  const RecommendedMovieState();

  @override
  List<Object> get props => [];
}

class RecommendedMovieLoading extends RecommendedMovieState {}

class RecommendedMovieLoaded extends RecommendedMovieState {
  final List<Movie> recommendedMovieList;

  const RecommendedMovieLoaded(this.recommendedMovieList);

  @override
  List<Object> get props => [recommendedMovieList];
}

class RecommendedMovieError extends RecommendedMovieState {}