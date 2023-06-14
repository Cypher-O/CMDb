import 'package:CMDb/model/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:CMDb/model/tvshow.dart';

abstract class SimilarMovieState extends Equatable {
  const SimilarMovieState();

  @override
  List<Object> get props => [];
}

class SimilarMovieLoading extends SimilarMovieState {}

class SimilarMovieLoaded extends SimilarMovieState {
  final List<Movie> similarMovieList;

  const SimilarMovieLoaded(this.similarMovieList);

  @override
  List<Object> get props => [similarMovieList];
}

class SimilarMovieError extends SimilarMovieState {}
