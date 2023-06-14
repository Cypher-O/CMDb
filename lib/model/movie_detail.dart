import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/genre.dart';
import 'package:CMDb/model/movie_image.dart';

class ProductionCompany {
  final int id;
  final String logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      logoPath: json['logo_path'],
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }
}

class MovieDetail {
  final String id;
  final String title;
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
  List<Genre> genres;
  List<ProductionCompany> productionCompanies;
  String trailerId;
  MovieImage movieImage;
  List<Cast> castList;

  MovieDetail(
      {this.id,
      this.title,
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
      this.productionCompanies});

  factory MovieDetail.fromJson(dynamic json) {
    if (json == null) {
      return MovieDetail();
    }

    return MovieDetail(
      id: json['id'].toString(),
      title: json['title'],
      backdropPath: json['backdrop_path'],
      budget: json['budget'].toString(),
      revenue: json['revenue']?.toString(),
      homePage: json['home_page'],
      originalTitle: json['original_title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      runtime: json['runtime'].toString(),
      voteAverage: json['vote_average'].toString(),
      voteCount: json['vote_count'].toString(),
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
      productionCompanies: (json['production_companies'] as List)
          .map((company) => ProductionCompany.fromJson(company))
          .toList(),
    );
  }
}
