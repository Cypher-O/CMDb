import 'dart:io';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc.dart';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc_event.dart';
import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/ui/rating_widget.dart';
import 'package:CMDb/ui/tv_detail_screen.dart';
import 'package:CMDb/widgets/bookmark_clipper.dart';
import 'package:CMDb/widgets/bookmark_painter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../model/tvshow.dart';

class RecommendedTvSeriesWidget extends StatelessWidget {
  final List<TvShow> recommendedTvShows;


  const RecommendedTvSeriesWidget({Key key, this.recommendedTvShows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecommendedTvShowBloc>(
      create: (_) =>
      RecommendedTvShowBloc()
        ..add(const RecommendedTvShowEventStarted(0, '')),
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
              itemCount: recommendedTvShows.length,
              itemBuilder:
                  (context, index) {
                TvShow tvShow =
                recommendedTvShows[index];
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
                                TvShowDetailScreen(
                                    tvShow:
                                    tvShow),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag:
                            "tvShowPoster${tvShow
                                .id}",
                            child:
                            ClipRRect(
                              child:
                              CachedNetworkImage(
                                imageUrl:
                                'https://image.tmdb.org/t/p/original/${tvShow
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
                            child: Consumer<WatchlistModel>(
                              builder: (context, watchlistModel, child) {
                                bool isAdded = watchlistModel.tvShowWatchlist.contains(tvShow);

                                return GestureDetector(
                                  onTap: () {
                                    if (isAdded) {
                                      watchlistModel.removeFromWatchlistTvShow(tvShow);
                                    } else {
                                      watchlistModel.addToWatchlistTvShow(tvShow);
                                    }
                                  },
                                  child: Container(
                                    width: 35.0,
                                    height: 40.0,
                                    child: ClipPath(
                                      clipper: BookmarkClipper(),
                                      child: CustomPaint(
                                        painter: BookmarkPainter(
                                          isAdded ? Colors.orange : Colors.black45,
                                          isAdded ? Colors.black : Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isAdded ? Icons.check_rounded : Icons.add,
                                            size: 30.0,
                                            color: isAdded ? Colors.white : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                        tvShow.name
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
                            voteAverage: tvShow
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
                            '${tvShow
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
