import 'dart:io';

import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc.dart';
import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc_event.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/ui/movie_detail_screen.dart';
import 'package:CMDb/ui/rating_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';


class RecommendedMovieWidget extends StatelessWidget {
  final List<Movie> recommendedMovies;


  const RecommendedMovieWidget({Key key, this.recommendedMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecommendedMovieBloc>(
      create: (_) =>
      RecommendedMovieBloc()
        ..add(const RecommendedMovieEventStarted(0, '')),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            child: ListView.separated(
              separatorBuilder:
                  (context, index) =>
              const VerticalDivider(
                color: Colors.transparent,
                width: 15,
              ),
              scrollDirection:
              Axis.horizontal,
              itemCount: recommendedMovies.length,
              itemBuilder:
                  (context, index) {
                Movie movie =
                recommendedMovies[index];
                // print("Recomended similar tvshows or series$similarTvShows.length");
                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (
                                context) =>
                                MovieDetailScreen(
                                    movie:
                                    movie),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag:
                            "tvShowPoster${movie
                                .id}",
                            child:
                            ClipRRect(
                              child:
                              CachedNetworkImage(
                                imageUrl:
                                'https://image.tmdb.org/t/p/original/${movie
                                    .posterPath}',
                                imageBuilder:
                                    (context,
                                    imageProvider) {
                                  return Container(
                                    width:
                                    165,
                                    height:
                                    250,
                                    decoration:
                                    BoxDecoration(
                                      borderRadius:
                                      const BorderRadius
                                          .all(
                                        Radius
                                            .circular(
                                            12),
                                      ),
                                      image:
                                      DecorationImage(
                                        image:
                                        imageProvider,
                                        fit:
                                        BoxFit
                                            .cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder:
                                    (context,
                                    url) =>
                                    Container(
                                      width:
                                      180,
                                      height:
                                      250,
                                      child:
                                      Center(
                                        child: Platform
                                            .isAndroid
                                            ? Container(
                                          child: const LoadingIndicator(
                                            indicatorType: Indicator
                                                .lineSpinFadeLoader,
                                          ),
                                          height: 15,
                                        )
                                            : const CupertinoActivityIndicator(),
                                      ),
                                    ),
                                errorWidget: (
                                    context,
                                    url,
                                    error) =>
                                    Container(
                                      width:
                                      180,
                                      height:
                                      250,
                                      decoration:
                                      const BoxDecoration(
                                        image:
                                        DecorationImage(
                                          image:
                                          AssetImage(
                                              'assets/images/image_not_found.jpeg'),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Colors
                                    .black26,
                              ),
                              child: const Icon(
                                  Icons.add,
                                  size:
                                  30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: 5),
                      width: 180,
                      child: Text(
                        movie.title
                            .toUpperCase(),
                        style:
                        const TextStyle(
                          fontSize: 12,
                          color:
                          Colors.white,
                          fontWeight:
                          FontWeight
                              .bold,
                          fontFamily:
                          'mulish',
                        ),
                        overflow:
                        TextOverflow
                            .ellipsis,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end,
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: <Widget>[
                          RatingWidget(
                            voteAverage: movie
                                .voteAverage,
                            starSize: 14,
                            starColor: Colors
                                .yellow,
                            emptyStarColor: Colors
                                .grey,
                          ),
                          // Icon(
                          //   Icons.star,
                          //   color: Colors.yellow,
                          //   size: 14,
                          // ),
                          SizedBox(width: 4),
                          // Adjust the spacing between the icon and text
                          Text(
                            '${movie
                                .voteAverage}\t/\t10',
                            style: TextStyle(
                              color: Colors
                                  .white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
