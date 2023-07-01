import 'package:CMDb/model/born_today.dart';
import 'package:CMDb/model/review.dart';
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
import 'package:CMDb/model/season.dart';
import 'package:CMDb/model/episode.dart';


class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = 'api_key=fda0f43d2c6247cad5a6b1caf737ec8d';
  final String token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZGEwZjQzZDJjNjI0N2NhZDVhNmIxY2FmNzM3ZWM4ZCIsInN1YiI6IjY0M2E4NzVlZTMyOTQzMDRmMmY5Yjg3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.pTgAEDA2aB6PPCdZUfPUEuPG2wMBxhobW-U1Ad8Kz5M';
  final String imageBaseUrl = 'https://image.tmdb.org/t/p/w92';

  Future<List<dynamic>> returnSearchResults(String query) async {
    final url = "$baseUrl/search/multi?$apiKey&query=$query";
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
        return responseData['results'];
      } else {
        throw Exception('Failed to parse search results');
      }
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
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getTopRatedMovie() async {
    try {
      final url = '$baseUrl/movie/top_rated?$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> topRatedMovieList = movies.map((m) => Movie.fromJson(m)).toList();
      return topRatedMovieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<TvShow>> getSimilarTvShow(int seriesId) async {
    try {
      final url = '$baseUrl/tv/$seriesId/similar?$apiKey';
      final response = await _dio.get(url);
      var tvShow = response.data['results'] as List;
      List<TvShow> similarTvShowList = tvShow.map((m) => TvShow.fromJson(m)).toList();
      // print('Fetching similar TV shows for seriesId: $seriesId');
      // print('Similar TV Shows: $similarTvShowList');
      return similarTvShowList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/similar?$apiKey';
      final response = await _dio.get(url);
      var movie = response.data['results'] as List;
      List<Movie> similarMovieList = movie.map((m) => Movie.fromJson(m)).toList();
      // print('Fetching similar TV shows for seriesId: $seriesId');
      // print('Similar TV Shows: $similarTvShowList');
      return similarMovieList;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<TvShow>> getTvShowRecommendations(int seriesId) async {
    try {
      final url = '$baseUrl/tv/$seriesId/recommendations?$apiKey';
      final response = await _dio.get(url);
      var tvShows = response.data['results'] as List;
      List<TvShow> tvShowRecommendationList = tvShows.map((m) => TvShow.fromJson(m)).toList();
      // print('Recommendations: $recommendationList');
      return tvShowRecommendationList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/recommendations?$apiKey';
      final response = await _dio.get(url);
      var movie = response.data['results'] as List;
      List<Movie> movieRecommendationList = movie.map((m) => Movie.fromJson(m)).toList();
      // print('Recommendations: $recommendationList');
      return movieRecommendationList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }


  Future<List<Review>> getTvShowsReviews(int seriesId) async {
    try {
      final url = '$baseUrl/tv/$seriesId/reviews?$apiKey';
      final response = await _dio.get(url);
      var reviews = response.data['results'] as List;
      List<Review> reviewList = reviews.map((m) => Review.fromJson(m)).toList();
      // print('Reviews: $reviewList');
      return reviewList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }
  Future<List<Review>> getAllTvShowsReviews() async {
    try {
      final url = '$baseUrl/tv/reviews?$apiKey';
      final response = await _dio.get(url);
      var reviews = response.data['results'] as List;
      List<Review> reviewList = reviews.map((m) => Review.fromJson(m)).toList();
      // print('Reviews: $reviewList');
      return reviewList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Review>> getMovieReviews(int movieId) async {
    try {
      final url = '$baseUrl/movie/$movieId/reviews?$apiKey';
      final response = await _dio.get(url);
      var reviews = response.data['results'] as List;
      List<Review> reviewList = reviews.map((m) => Review.fromJson(m)).toList();
      // print('Reviews: $reviewList');
      return reviewList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Review>> getAllMovieReviews() async {
    try {
      final url = '$baseUrl/movie/reviews?$apiKey';
      final response = await _dio.get(url);
      var reviews = response.data['results'] as List;
      List<Review> reviewList = reviews.map((m) => Review.fromJson(m)).toList();
      // print('Reviews: $reviewList');
      return reviewList;
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }


  Future<MovieDetail> getMovieSpecificGenres(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId?$apiKey&append_to_response=genres');
      return MovieDetail.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowDetail> getTvShowSpecificGenres (int tvShowId) async{
    try {
      final response = await _dio.get('$baseUrl/tv/$tvShowId?$apiKey&append_to_response=genres');
      return TvShowDetail.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowDetail> getTvShowDetail(int tvShowId) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$tvShowId?$apiKey');
      TvShowDetail tvShowDetail = TvShowDetail.fromJson(response.data);

      tvShowDetail.trailerId = await getTvShowsYoutubeId(tvShowId);

      tvShowDetail.tvShowImage = await getTvShowImage(tvShowId);

      tvShowDetail.castList = await getTvShowCastList(tvShowId);

      tvShowDetail.tvShow = await getSimilarTvShow(tvShowId);

      return tvShowDetail;
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  // Future<String> getYoutubeId(int id) async {
  //   try {
  //     final response = await _dio.get('$baseUrl/movie/$id/videos?$apiKey');
  //     var youtubeId = response.data['results'][0]['key'];
  //     return youtubeId;
  //   } catch (error, stacktrace) {
  //     throw Exception(
  //         'Exception occurred: $error with stacktrace: $stacktrace');
  //   }
  // }
  Future<String> getYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$id/videos?$apiKey');
      var results = response.data['results'];
      if (results.isNotEmpty) {
        var youtubeId = results[0]['key'];
        return youtubeId;
      } else {
        return ''; // Return default value when no YouTube video is found
      }
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getTvShowsYoutubeId(int id) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$id/videos?$apiKey');
      var results = response.data['results'];
      if (results.isNotEmpty) {
        var youtubeId = results[0]['key'];
        return youtubeId;
      } else {
        return ''; // Return default value when no YouTube video is found
      }
    } catch (error, stacktrace) {
      throw Exception('Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  // Future<String> getTvShowsYoutubeId(int id) async {
  //   try {
  //     final response = await _dio.get('$baseUrl/tv/$id/videos?$apiKey');
  //     var youtubeId = response.data['results'][0]['key'];
  //     return youtubeId;
  //   } catch (error, stacktrace) {
  //     throw Exception(
  //         'Exception occurred: $error with stacktrace: $stacktrace');
  //   }
  // }
  Future<Season> getSeason(int showId, int seasonNumber) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$showId/season/$seasonNumber',
          queryParameters: {'api_key': apiKey});

      if (response.statusCode == 200) {
        final data = response.data;
        return Season.fromJson(data);
      } else {
        throw Exception('Failed to fetch season details');
      }
    } catch (e) {
      throw Exception('Failed to fetch season details: $e');
    }
  }

  Future<List<Episode>> getEpisodes(int showId, int seasonNumber) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$showId/season/$seasonNumber',
          queryParameters: {'api_key': apiKey},
          options: Options(headers: {'Authorization': 'Bearer $token'}),);

      print(response.data);

      if (response.statusCode == 200) {
        final data = response.data['episodes'] as List<dynamic>;
        final List<Episode> episodes = data.map((episodeData) => Episode.fromJson(episodeData)).toList();
        return episodes;
      } else {
        throw Exception('Failed to fetch episodes');
      }
    } catch (e) {
      throw Exception('Failed to fetch episodes: $e');
    }
  }

  // Future<List<BornToday>> getBornToday({int page = 1, int pageSize = 20}) async {
  //   try {
  //     final now = DateTime.now();
  //     final formattedDate = '${now.month}-${now.day}';
  //     final cache = <int, DateTime>{};
  //
  //     final List<BornToday> birthdays = [];
  //
  //     while (true) {
  //       final response = await _dio.get(
  //         '$baseUrl/person/popular',
  //         queryParameters: {'api_key': apiKey, 'page': page, 'page_size': pageSize},
  //         options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         final data = response.data['results'] as List<dynamic>;
  //
  //         for (final person in data) {
  //           final personId = person['id'] as int;
  //           final cachedBirthday = cache[personId];
  //
  //           if (cachedBirthday != null) {
  //             final personFormattedDate = '${cachedBirthday.month}-${cachedBirthday.day}';
  //             if (personFormattedDate == formattedDate) {
  //               birthdays.add(BornToday.fromJson(person));
  //             }
  //           } else {
  //             final personResponse = await _dio.get(
  //               '$baseUrl/person/$personId',
  //               queryParameters: {'api_key': apiKey},
  //               options: Options(headers: {'Authorization': 'Bearer $token'}),
  //             );
  //
  //             final birthdayString = personResponse.data['birthday'];
  //             if (birthdayString != null) {
  //               final birthday = DateTime.parse(birthdayString);
  //               cache[personId] = birthday;
  //               final personFormattedDate = '${birthday.month}-${birthday.day}';
  //               if (personFormattedDate == formattedDate) {
  //                 birthdays.add(BornToday.fromJson(personResponse.data));
  //               }
  //             }
  //           }
  //         }
  //
  //         if (page >= response.data['total_pages']) {
  //           break; // Break the loop if all pages have been fetched
  //         }
  //
  //         page++;
  //       } else {
  //         throw Exception('Failed to fetch birthdays. Status code: ${response.statusCode}');
  //       }
  //     }
  //
  //     return birthdays;
  //   } catch (e, stackTrace) {
  //     print('Error fetching born today: $e');
  //     print(stackTrace);
  //     throw Exception('Failed to fetch born today: $e');
  //   }
  // }

  // Future<List<BornToday>> getBornToday({int page = 1, int pageSize = 20}) async {
  //   try {
  //     final now = DateTime.now();
  //     final formattedDate = '${now.month}-${now.day}';
  //     final cache = <int, DateTime>{};
  //
  //     final List<BornToday> birthdays = [];
  //
  //     print('Fetching born today data...');
  //
  //     while (true) {
  //       final response = await _dio.get(
  //         '$baseUrl/person/popular',
  //         queryParameters: {'api_key': apiKey, 'page': page, 'page_size': pageSize},
  //         options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         final data = response.data['results'] as List<dynamic>;
  //
  //         if (data.isEmpty) {
  //           // No more data available, break the loop
  //           break;
  //         }
  //
  //         for (final person in data) {
  //           final personId = person['id'] as int;
  //           final cachedBirthday = cache[personId];
  //
  //           if (cachedBirthday != null) {
  //             final personFormattedDate = '${cachedBirthday.month}-${cachedBirthday.day}';
  //             if (personFormattedDate == formattedDate) {
  //               final bornToday = BornToday.fromJson(person);
  //               birthdays.add(bornToday);
  //               // print('Birthday added: $bornToday');
  //             }
  //           } else {
  //             final personResponse = await _dio.get(
  //               '$baseUrl/person/$personId',
  //               queryParameters: {'api_key': apiKey},
  //               options: Options(headers: {'Authorization': 'Bearer $token'}),
  //             );
  //
  //             final birthdayString = personResponse.data['birthday'];
  //             if (birthdayString != null) {
  //               final birthday = DateTime.parse(birthdayString);
  //               cache[personId] = birthday;
  //               final personFormattedDate = '${birthday.month}-${birthday.day}';
  //               if (personFormattedDate == formattedDate) {
  //                 final bornToday = BornToday.fromJson(personResponse.data);
  //                 birthdays.add(bornToday);
  //                 print('Birthday added: $bornToday');
  //               }
  //             }
  //           }
  //         }
  //       } else {
  //         throw Exception('Failed to fetch birthdays. Status code: ${response.statusCode}');
  //       }
  //
  //       page++;
  //     }
  //
  //     print('Born today data fetched successfully.');
  //     return birthdays;
  //   } catch (e, stackTrace) {
  //     print('Error fetching born today: $e');
  //     print(stackTrace);
  //     throw Exception('Failed to fetch born today: $e');
  //   }
  // }


  // Future<List<BornToday>> getBornToday({int page = 1, int pageSize = 20, int totalPageLimit = 500}) async {
  //   try {
  //     final now = DateTime.now();
  //     final formattedDate = '${now.month}-${now.day}';
  //     final cache = <int, DateTime>{};
  //
  //     final List<BornToday> birthdays = [];
  //
  //     while (page <= totalPageLimit) {
  //       final response = await _dio.get(
  //         '$baseUrl/person/popular',
  //         queryParameters: {'api_key': apiKey, 'page': page, 'page_size': pageSize},
  //         options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         final data = response.data['results'] as List<dynamic>;
  //
  //         for (final person in data) {
  //           final personId = person['id'] as int;
  //           final cachedBirthday = cache[personId];
  //
  //           if (cachedBirthday != null) {
  //             final personFormattedDate = '${cachedBirthday.month}-${cachedBirthday.day}';
  //             if (personFormattedDate == formattedDate) {
  //               birthdays.add(BornToday.fromJson(person));
  //             }
  //           } else {
  //             final personResponse = await _dio.get(
  //               '$baseUrl/person/$personId',
  //               queryParameters: {'api_key': apiKey},
  //               options: Options(headers: {'Authorization': 'Bearer $token'}),
  //             );
  //
  //             final birthdayString = personResponse.data['birthday'];
  //             if (birthdayString != null) {
  //               final birthday = DateTime.parse(birthdayString);
  //               cache[personId] = birthday;
  //               final personFormattedDate = '${birthday.month}-${birthday.day}';
  //               if (personFormattedDate == formattedDate) {
  //                 birthdays.add(BornToday.fromJson(personResponse.data));
  //               }
  //             }
  //           }
  //         }
  //       } else {
  //         throw Exception('Failed to fetch birthdays. Status code: ${response.statusCode}');
  //       }
  //
  //       page++;
  //     }
  //
  //     return birthdays;
  //   } catch (e, stackTrace) {
  //     print('Error fetching born today: $e');
  //     print(stackTrace);
  //     throw Exception('Failed to fetch born today: $e');
  //   }
  // }

  // Future<List<BornToday>> getBornToday({int page = 1, int pageSize = 20, int totalPageLimit = 500}) async {
  //   try {
  //     final now = DateTime.now();
  //     final formattedDate = '${now.month}-${now.day}';
  //     final cache = <int, DateTime>{};
  //
  //     final List<BornToday> birthdays = [];
  //
  //     while (page <= totalPageLimit) {
  //       final response = await _dio.get(
  //         '$baseUrl/person/popular',
  //         queryParameters: {'api_key': apiKey, 'page': page, 'page_size': pageSize},
  //         options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         final data = response.data['results'] as List<dynamic>;
  //
  //         for (final person in data) {
  //           final personId = person['id'] as int;
  //           final cachedBirthday = cache[personId];
  //
  //           if (cachedBirthday != null) {
  //             final personFormattedDate = '${cachedBirthday.month}-${cachedBirthday.day}';
  //             if (personFormattedDate == formattedDate) {
  //               // final bornToday = BornToday.fromJson(person);
  //               // birthdays.add(bornToday);
  //               birthdays.add(BornToday.fromJson(person));
  //             }
  //           } else {
  //             final personResponse = await _dio.get(
  //               '$baseUrl/person/$personId',
  //               queryParameters: {'api_key': apiKey},
  //               options: Options(headers: {'Authorization': 'Bearer $token'}),
  //             );
  //
  //             final birthdayString = personResponse.data['birthday'];
  //             if (birthdayString != null) {
  //               final birthday = DateTime.parse(birthdayString);
  //               cache[personId] = birthday;
  //               final personFormattedDate = '${birthday.month}-${birthday.day}';
  //               if (personFormattedDate == formattedDate) {
  //                 // final bornToday = BornToday.fromJson(personResponse.data);
  //                 // birthdays.add(bornToday);
  //                 birthdays.add(BornToday.fromJson(personResponse.data));
  //               }
  //             }
  //           }
  //         }
  //       } else {
  //         throw Exception('Failed to fetch birthdays. Status code: ${response.statusCode}');
  //       }
  //
  //       if (birthdays.length >= totalPageLimit) {
  //         break; // Break the loop if the total page limit is reached
  //       }
  //       page++;
  //     }
  //
  //     print('Birthdays retrieved: ${birthdays.length}');
  //
  //     return birthdays;
  //   } catch (e, stackTrace) {
  //     print('Error fetching born today: $e');
  //     print(stackTrace);
  //     throw Exception('Failed to fetch born today: $e');
  //   }
  // }
  Future<List<BornToday>> getBornToday({int page = 1, int pageSize = 20, int totalPageLimit = 500}) async {
    try {
      final now = DateTime.now();
      final formattedDate = '${now.month}-${now.day}';
      final cache = <int, DateTime>{};

      final List<BornToday> birthdays = [];

      while (birthdays.length < totalPageLimit) {
        final response = await _dio.get(
          '$baseUrl/person/popular',
          queryParameters: {'api_key': apiKey, 'page': page, 'page_size': pageSize},
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (response.statusCode == 200) {
          final data = response.data['results'] as List<dynamic>;

          for (final person in data) {
            final personId = person['id'] as int;
            final cachedBirthday = cache[personId];

            if (cachedBirthday != null) {
              final personFormattedDate = '${cachedBirthday.month}-${cachedBirthday.day}';
              if (personFormattedDate == formattedDate) {
                birthdays.add(BornToday.fromJson(person));
                print('Birthday added: ${BornToday.fromJson(person)}');
              }
            } else {
              final personResponse = await _dio.get(
                '$baseUrl/person/$personId',
                queryParameters: {'api_key': apiKey},
                options: Options(headers: {'Authorization': 'Bearer $token'}),
              );

              final birthdayString = personResponse.data['birthday'];
              if (birthdayString != null) {
                final birthday = DateTime.parse(birthdayString);
                cache[personId] = birthday;
                final personFormattedDate = '${birthday.month}-${birthday.day}';
                if (personFormattedDate == formattedDate) {
                  birthdays.add(BornToday.fromJson(personResponse.data));
                  print('Birthday added: ${BornToday.fromJson(personResponse.data)}');
                }
              }
            }
          }
        } else {
          throw Exception('Failed to fetch birthdays. Status code: ${response.statusCode}');
        }

        page++;

        if (page > totalPageLimit) {
          break; // Break the loop if the total page limit is reached
        }
      }

      print('Birthdays retrieved: ${birthdays.length}');

      return birthdays;
    } catch (e, stackTrace) {
      print('Error fetching born today: $e');
      print(stackTrace);
      throw Exception('Failed to fetch born today: $e');
    }
  }


  Future<MovieImage> getMovieImage(int movieId) async {
    try {
      final response = await _dio.get('$baseUrl/movie/$movieId/images?$apiKey');
      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }

  Future<TvShowImage> getTvShowImage(int tvShowId) async {
    try {
      final response = await _dio.get('$baseUrl/tv/$tvShowId/images?$apiKey');
      return TvShowImage.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception(
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
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
          'Exception occurred: $error with stacktrace: $stacktrace');
    }
  }
}