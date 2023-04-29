import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/tv_show_image.dart';

class TvShowDetail {
  final String id;
  final String name;
  final String backdropPath;
  final String budget;
  final String homePage;
  final String originalTitle;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final String runtime;
  final String voteAverage;
  final String voteCount;

  String trailerId;

  TvShowImage tvShowImage;

  List<Cast> castList;

  TvShowDetail(
      {this.id,
        this.name,
        this.backdropPath,
        this.budget,
        this.homePage,
        this.originalTitle,
        this.posterPath,
        this.overview,
        this.releaseDate,
        this.runtime,
        this.voteAverage,
        this.voteCount});

  factory TvShowDetail.fromJson(dynamic json) {
    if (json == null) {
      return TvShowDetail();
    }

    return TvShowDetail(
        id: json['id'].toString(),
        name: json['name'],
        backdropPath: json['backdrop_path'],
        budget: json['budget'].toString(),
        homePage: json['home_page'],
        originalTitle: json['original_title'],
        posterPath: json['poster_path'],
        overview: json['overview'],
        releaseDate: json['first_air_date'],
        runtime: json['runtime'].toString(),
        voteAverage: json['vote_average'].toString(),
        voteCount: json['vote_count'].toString());
  }
}
