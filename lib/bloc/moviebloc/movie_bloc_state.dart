import 'package:equatable/equatable.dart';
import 'package:CMDb/model/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movieList;
  final List<Movie> topRatedMovieList;

  const MovieLoaded(this.movieList, this.topRatedMovieList);

  @override
  List<Object> get props {
    return [movieList, topRatedMovieList];
  }
}

class MovieError extends MovieState {}
