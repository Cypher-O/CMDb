import 'package:CMDb/model/tv_show_image.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/tvshow_detail.dart';
import 'package:dio/dio.dart';
import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/genre.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/movie_detail.dart';
import 'package:CMDb/model/movie_image.dart';
import 'package:CMDb/model/person.dart';
import 'dart:convert';

class ApiService {
  final Dio _dio = Dio();
  // List<dynamic> _searchResults = [];

  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'api_key=fda0f43d2c6247cad5a6b1caf737ec8d';


  Future<List<dynamic>> returnSearchResults(String query) async {
    final url = "$baseUrl/search/multi?$apiKey&query=$query";
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.data)['results'];
        // _searchResults = json.decode(response.data)['results'];
    } else {
      throw Exception('Failed to search for movies and TV shows');
    }
  }


  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      final url = '$baseUrl/movie/now_playing?$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }
  Future<List<TvShow>> getPopularTvShow() async {
    try {
      final url = '$baseUrl/tv/top_rated?$apiKey';
      final response = await _dio.get(url);
      var tvShow = response.data['results'] as List;
      List<TvShow> tvShowList = tvShow.map((m) => TvShow.fromJson(m)).toList();
      return tvShowList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getMovieByGenre(int movieId) async {
    try {
      final url = '$baseUrl/discover/movie?with_genres=$movieId&$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Genre>> getGenreList() async {
    try {
      final response = await _dio.get('$baseUrl/genre/movie/list?$apiKey');
      var genres = response.data['genres'] as List;
      List<Genre> genreList = genres.map((g) => Genre.fromJson(g)).toList();
      return genreList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Person>> getTrendingPerson() async {
    try {
      final response = await _dio.get('$baseUrl/trending/person/week?$apiKey');
      var persons = response.data['results'] as List;
      List<Person> personList = persons.map((p) => Person.fromJson(p)).toList();
      // print(persons);
      return personList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId?$apiKey');
      MovieDetail movieDetail = MovieDetail.fromJson(response.data);

      movieDetail.trailerId = await getYoutubeId(movieId);

      movieDetail.movieImage = await getMovieImage(movieId);

      movieDetail.castList = await getCastList(movieId);

      return movieDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowDetail> getTvShowDetail(int tvShowId) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$tvShowId?$apiKey');
      TvShowDetail tvShowDetail = TvShowDetail.fromJson(response.data);

      tvShowDetail.trailerId = await getTvShowsYoutubeId(tvShowId);

      tvShowDetail.tvShowImage = await getTvShowImage(tvShowId);

      tvShowDetail.castList = await getTvShowCastList(tvShowId);

      return tvShowDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$id/videos?$apiKey');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getTvShowsYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$id/videos?$apiKey');
      var youtubeId = response.data['results'][0]['key'];
      return youtubeId;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId/images?$apiKey');
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowImage> getTvShowImage(int tvShowId) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$tvShowId/images?$apiKey');
      return TvShowImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async {
    try {
      final response =
          await _dio.get('$baseUrl/movie/$movieId/credits?$apiKey');
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
              name: c['name'],
              profilePath: c['profile_path'],
              character: c['character']))
          .toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getTvShowCastList(int tvShowId) async {
    try {
      final response =
      await _dio.get('$baseUrl/tv/$tvShowId/credits?$apiKey');
      var list = response.data['cast'] as List;
      List<Cast> castList = list
          .map((c) => Cast(
          name: c['name'],
          profilePath: c['profile_path'],
          character: c['character']))
          .toList();
      return castList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occured: $error with stacktrace: $stacktrace');
    }
  }
}
