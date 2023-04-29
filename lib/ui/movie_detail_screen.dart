import 'dart:io';

import 'package:CMDb/bloc/moviedetailbloc/movie_detail_bloc.dart';
import 'package:CMDb/bloc/moviedetailbloc/movie_detail_event.dart';
import 'package:CMDb/bloc/moviedetailbloc/movie_detail_state.dart';
import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/movie_detail.dart';
import 'package:CMDb/model/screen_shot.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  final int initialIndex;

  const MovieDetailScreen({Key key, this.movie, this.initialIndex = 0})
      : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _currentIndex = 0;
  bool showMore = false;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final PageController pageController = PageController(initialPage: 0);
    // int currentIndex = 0;
    //
    // void onPageChanged(int index) {
    //   currentIndex = index;
    // }
    return BlocProvider(
      create: (_) =>
          MovieDetailBloc()..add(MovieDetailEventStated(widget.movie.id)),
      child: WillPopScope(
        child: Scaffold(
          body: _buildDetailBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state is MovieDetailLoading) {
          return Center(
            child: Platform.isAndroid
                ? const Padding(
                    padding: EdgeInsets.all(150.0),
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineSpinFadeLoader,
                    ),
                  )
                : const CupertinoActivityIndicator(),
          );
        } else if (state is MovieDetailLoaded) {
          MovieDetail movieDetail = state.detail;
          return SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/original/${movieDetail.posterPath}',
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Platform.isAndroid
                          ? const Padding(
                              padding: EdgeInsets.all(150.0),
                              child: LoadingIndicator(
                                indicatorType: Indicator.lineSpinFadeLoader,
                              ),
                            )
                          : const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/image_not_found.jpeg'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 120),
                      child: GestureDetector(
                        onTap: () async {
                          final youtubeUrl =
                              'https://www.youtube.com/embed/${movieDetail.trailerId}';
                          if (await canLaunch(youtubeUrl)) {
                            await launch(youtubeUrl);
                          }
                        },
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              const Icon(
                                Icons.play_circle_outline,
                                color: Colors.yellow,
                                size: 65,
                              ),
                              Text(
                                movieDetail.title.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'mulish',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 160,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 120),
                      // padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Overview'.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  ReadMoreText(
                                    movieDetail.overview,
                                    trimLines: showMore ? null : 2,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: ' Show less',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'mulish',
                                      // fontWeight: FontWeight.bold,
                                      // color: Colors.black,
                                    ),
                                    moreStyle: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'mulish',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Release date'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                    Text(
                                      movieDetail.releaseDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                            color: Colors.yellow[800],
                                            fontSize: 12,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'run time'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                    Text(
                                      movieDetail.runtime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                            color: Colors.yellow[800],
                                            fontSize: 12,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'budget'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                    Text(
                                      movieDetail.budget,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                            color: Colors.yellow[800],
                                            fontSize: 12,
                                            fontFamily: 'mulish',
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Screenshots'.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'mulish',
                                      ),
                            ),
                            Container(
                              height: 155,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    movieDetail.movieImage.backdrops.length,
                                itemBuilder: (context, index) {
                                  Screenshot image =
                                      movieDetail.movieImage.backdrops[index];
                                  return Container(
                                    child: Card(
                                      elevation: 3,
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: GestureDetector(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Platform.isAndroid
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(150.0),
                                                      child: LoadingIndicator(
                                                        indicatorType: Indicator
                                                            .lineSpinFadeLoader,
                                                      ),
                                                    )
                                                  : const CupertinoActivityIndicator(),
                                            ),
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                            fit: BoxFit.cover,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                  backgroundColor: Colors.black,
                                                  body: Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                PhotoViewGallery
                                                                    .builder(
                                                              itemCount:
                                                                  movieDetail
                                                                      .movieImage
                                                                      .backdrops
                                                                      .length,
                                                              builder: (BuildContext
                                                                      context,
                                                                  int index) {
                                                                return PhotoViewGalleryPageOptions(
                                                                  imageProvider:
                                                                      CachedNetworkImageProvider(
                                                                    'https://image.tmdb.org/t/p/w500${movieDetail.movieImage.backdrops[index].imagePath}',
                                                                  ),
                                                                  heroAttributes:
                                                                      PhotoViewHeroAttributes(
                                                                    tag:
                                                                        'image${movieDetail.movieImage.backdrops[index].imagePath}',
                                                                  ),
                                                                );
                                                              },
                                                              scrollPhysics:
                                                                  const BouncingScrollPhysics(),
                                                              backgroundDecoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              pageController:
                                                                  _pageController,
                                                              onPageChanged:
                                                                  onPageChanged,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 110,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          // color: Colors.wh,
                                                          //     .withOpacity(0.5),
                                                          child: Row(
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            children: [
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .close),
                                                                color: Colors
                                                                    .white,
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              // const SizedBox(
                                                              //     width: 40),
                                                              // Text(
                                                              //   'Image ${_currentIndex + 1} of ${movieDetail.movieImage.backdrops.length}',
                                                              //   style:
                                                              //       const TextStyle(
                                                              //     color: Colors
                                                              //         .white,
                                                              //     fontSize: 16,
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),

                                        // child: GestureDetector(
                                        //   child: CachedNetworkImage(
                                        //     placeholder: (context, url) => Center(
                                        //       child: Platform.isAndroid
                                        //           ? const Padding(
                                        //               padding:
                                        //                   EdgeInsets.all(150.0),
                                        //               child: LoadingIndicator(
                                        //                 indicatorType: Indicator
                                        //                     .lineSpinFadeLoader,
                                        //               ),
                                        //             )
                                        //           : const CupertinoActivityIndicator(),
                                        //     ),
                                        //     imageUrl:
                                        //         'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        //   onTap: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) => Scaffold(
                                        //           // appBar: AppBar(),
                                        //           // body: PhotoView(
                                        //           //   imageProvider:
                                        //           //   CachedNetworkImageProvider('https://image.tmdb.org/t/p/w500${image.imagePath}'),
                                        //           //   initialScale: PhotoViewComputedScale.contained * 1,
                                        //           //   // initialScale: PhotoViewComputedScale.contained,
                                        //           //   heroAttributes: PhotoViewHeroAttributes(
                                        //           //     tag: 'image${image.imagePath}',
                                        //           //   ),
                                        //           // ),
                                        //
                                        //           body: PhotoViewGallery(
                                        //
                                        //           )
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        // ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Cast &  Crew'.toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'mulish',
                                      ),
                            ),
                            Container(
                              height: 110,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) =>
                                    const VerticalDivider(
                                  color: Colors.transparent,
                                  width: 5,
                                ),
                                itemCount: movieDetail.castList.length,
                                itemBuilder: (context, index) {
                                  Cast cast = movieDetail.castList[index];
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          elevation: 3,
                                          child: ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                              imageBuilder:
                                                  (context, imageBuilder) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    image: DecorationImage(
                                                      image: imageBuilder,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  Container(
                                                width: 80,
                                                height: 80,
                                                child: Center(
                                                  child: Platform.isAndroid
                                                      ? const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  150.0),
                                                          child:
                                                              LoadingIndicator(
                                                            indicatorType: Indicator
                                                                .lineSpinFadeLoader,
                                                          ),
                                                        )
                                                      : const CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 80,
                                                height: 80,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/image_not_found.jpg'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              cast.name.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontFamily: 'mulish',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              cast.character.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontFamily: 'mulish',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
