import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/season.dart';
import 'package:CMDb/model/tv_show_image.dart';
import 'package:CMDb/model/tvshow.dart';
import 'episode.dart';
import 'genre.dart';

class TvShowDetail {
  final int id;
  final String name;
  final String backdropPath;
  final String budget;
  final String revenue;
  final String homePage;
  final String originalTitle;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final String runtime;
  final String voteAverage;
  final String voteCount;
  final List<Season> seasons;
  List<Episode> episodes;
  final List<Genre> genres;
  List<TvShow> tvShow;
  String trailerId;
  TvShowImage tvShowImage;
  List<Cast> castList;

  TvShowDetail({this.id,
    this.name,
    this.backdropPath,
    this.budget,
    this.revenue,
    this.homePage,
    this.originalTitle,
    this.posterPath,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.voteAverage,
    this.voteCount,
    this.genres,
    this.seasons,
    this.episodes, this.tvShow,});

  factory TvShowDetail.fromJson(dynamic json) {
    if (json == null) {
      return TvShowDetail();
    }
    final episodesData = json['episodes'] as List<dynamic>;
    List<Episode> episodes;
    if (episodesData != null) {
      episodes = episodesData.map((episode) => Episode.fromJson(episode)).toList();
    } else {
      episodes = [];
    }
    return TvShowDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      backdropPath: json['backdrop_path'] as String,
      budget: json['budget']?.toString(),
      revenue: json['revenue']?.toString(),
      homePage: json['home_page'] as String,
      originalTitle: json['original_title'] as String,
      posterPath: json['poster_path'] as String,
      overview: json['overview'] as String,
      releaseDate: json['first_air_date'] as String,
      runtime: json['runtime']?.toString(),
      voteAverage: json['vote_average']?.toString(),
      voteCount: json['vote_count']?.toString(),
      genres: (json['genres'] as List<dynamic>).map((genre) =>
          Genre.fromJson(genre)).toList(),
      seasons: (json['seasons'] as List<dynamic>)
          .map((season) => Season.fromJson(season))
          .toList(),
      episodes: episodes,
      tvShow: [],
    );
  }
}
