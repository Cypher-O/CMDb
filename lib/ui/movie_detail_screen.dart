import 'dart:io';

import 'package:CMDb/bloc/moviedetailbloc/movie_detail_bloc.dart';
import 'package:CMDb/bloc/moviedetailbloc/movie_detail_event.dart';
import 'package:CMDb/bloc/moviedetailbloc/movie_detail_state.dart';
import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc.dart';
import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc_event.dart';
import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc_state.dart';
import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc.dart';
import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc_event.dart';
import 'package:CMDb/bloc/recommendedmoviebloc/recommended_movie_bloc_state.dart';
import 'package:CMDb/bloc/similarmoviebloc/similar_movie_bloc.dart';
import 'package:CMDb/bloc/similarmoviebloc/similar_movie_bloc_event.dart';
import 'package:CMDb/bloc/similarmoviebloc/similar_movie_bloc_state.dart';
import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/genre.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/movie_detail.dart';
import 'package:CMDb/model/review.dart';
import 'package:CMDb/model/screen_shot.dart';
import 'package:CMDb/widgets/recommended_movie_widgets.dart';
import 'package:CMDb/widgets/review_movie_widget.dart';
import 'package:CMDb/widgets/similar_movie_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  final int initialIndex;
  final MovieDetail movieDetail;

  const MovieDetailScreen({
    Key key,
    this.movie,
    this.initialIndex = 0,
    this.movieDetail,
  }) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _currentIndex = 0;
  bool showMore = false;
  PageController _pageController;
  bool _isVideoPlayerVisible = false;
  YoutubePlayerController _youtubeController;

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeVideo();
  // }
  //
  // void _initializeVideo() {
  //   if (widget.movieDetail != null && widget.movieDetail.trailerId != null) {
  //     _youtubeController = YoutubePlayerController(
  //       initialVideoId: widget.movieDetail.trailerId,
  //       flags: YoutubePlayerFlags(
  //         autoPlay: true,
  //         mute: false,
  //       ),
  //     );
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _youtubeController.dispose();
  //   super.dispose();
  // }
  //
  // void _openPlayerFullscreen() {
  //   print("i was just tapped");
  //   if (widget.movieDetail != null && widget.movieDetail.trailerId != null) {
  //     setState(() {
  //       _isVideoPlayerVisible = true;
  //     });
  //   }
  // }
  //
  //
  // void _closePlayerFullscreen() {
  //   setState(() {
  //     _isVideoPlayerVisible = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MovieDetailBloc()..add(MovieDetailEventStated(widget.movie.id)),
        ),
        BlocProvider<SimilarMovieBloc>(
          create: (_) => SimilarMovieBloc()
            ..add(SimilarMovieEventStarted(widget.movie.id, '')),
        ),
        BlocProvider<RecommendedMovieBloc>(
          create: (_) => RecommendedMovieBloc()
            ..add(RecommendedMovieEventStarted(widget.movie.id, '')),
        ),
        BlocProvider<MovieReviewBloc>(
          create: (_) => MovieReviewBloc()
            ..add(MovieReviewEventStarted(widget.movie.id, '')),
        ),
      ],
      child: WillPopScope(
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          body: _buildDetailBody(context),
          // body: Stack(
          //   children: [
          //     _buildDetailBody(context),
          //     if (_isVideoPlayerVisible && widget.movieDetail != null)
          //       _buildFullscreenVideoPlayer(),
          //   ],
          // ),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  // Widget _buildFullscreenVideoPlayer() {
  //   if (widget.movieDetail == null || widget.movieDetail.trailerId == null) {
  //     // Return null if movieDetail or trailerId is null
  //     return null;
  //   }
  //
  //   final String trailerId = widget.movieDetail.trailerId;
  //
  //   // Validate trailerId to ensure it is a valid YouTube video ID
  //   final RegExp regex = RegExp(
  //     r"^(?:(?:http(?:s)?:\/\/)?(?:www\.)?)?(?:(?:youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))|(?:youtu\.be\/))([a-zA-Z0-9\-_]+)",
  //     caseSensitive: false,
  //     multiLine: false,
  //   );
  //
  //   if (!regex.hasMatch(trailerId)) {
  //     // Return null if trailerId is not a valid YouTube video ID
  //     return null;
  //   }
  //
  //   print("Trailer ID: $trailerId"); // Add this print statement to check the value
  //
  //   return Container(
  //     color: Colors.black,
  //     child: YoutubePlayer(
  //       controller: _youtubeController,
  //       showVideoProgressIndicator: true,
  //       progressIndicatorColor: Colors.amber,
  //       progressColors: ProgressBarColors(
  //         playedColor: Colors.amber,
  //         handleColor: Colors.amberAccent,
  //       ),
  //       onReady: () {
  //         // Perform any necessary actions when the video is ready to play
  //       },
  //       onEnded: (data) {
  //         // Perform any necessary actions when the video has ended
  //       },
  //     ),
  //   );
  // }

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
          final runtime = double.parse(movieDetail.runtime ?? "0").toInt();
          final hours = runtime ~/ 60;
          final minutes = runtime % 60;

          final budget = int.parse(movieDetail.budget ?? "0");
          final revenue = int.parse(movieDetail.revenue ?? "0");
          final formattedBudget = NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: '\$',
          ).format(budget);
          final formattedRevenue = NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: '\$',
          ).format(revenue);

          final budgetSymbol = budget >= 1000000000
              ? 'B'
              : budget >= 1000000
                  ? 'M'
                  : '';
          final revenueSymbol = revenue >= 1000000000
              ? 'B'
              : revenue >= 1000000
                  ? 'M'
                  : '';
          final finalFormattedBudget = budgetSymbol.isEmpty
              ? formattedBudget
              : formattedBudget.substring(0, formattedBudget.length - 1) +
              budgetSymbol;
          final finalFormattedRevenue = revenueSymbol.isEmpty
              ? formattedRevenue
              : formattedRevenue.substring(0, formattedRevenue.length - 1) +
                  revenueSymbol;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  // snap: true,
                  // floating: true,
                  // title: Text(
                  //   movieDetail.title.toUpperCase(),
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'mulish',
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  expandedHeight: MediaQuery.of(context).size.height / 2,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        title: Text(
                          movieDetail.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        background: ClipPath(
                          child: Hero(
                            tag: 'moviePoster${movieDetail.id}',
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
                                        indicatorType:
                                            Indicator.lineSpinFadeLoader,
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
                      ),
                      Positioned(
                        top: 300,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  final youtubeUrl =
                                      'https://www.youtube.com/embed/${movieDetail.trailerId}';
                                  if (await canLaunch(youtubeUrl)) {
                                    await launch(youtubeUrl);
                                  }
                                },
                                // onTap: _openPlayerFullscreen,
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.yellow,
                                  size: 65,
                                ),
                              ),
                              // Text(
                              //   movieDetail.title.toUpperCase(),
                              //   style: const TextStyle(
                              //     color: Colors.white,
                              //     fontFamily: 'mulish',
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Plot Summary'.toUpperCase(),
                            style: Theme.of(context).textTheme.caption.copyWith(
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
                            trimCollapsedText: 'Read more',
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
                    Text(
                      'Genres'.toUpperCase(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'mulish',
                          ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 45,
                      // width: 300,
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const VerticalDivider(
                          color: Colors.transparent,
                          width: 4,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: movieDetail.genres.length,
                        itemBuilder: (context, index) {
                          Genre genre = movieDetail.genres[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle genre selection if needed
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  child: Text(
                                    genre.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'mulish',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Release date'.toUpperCase(),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    fontFamily: 'mulish',
                                  ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              movieDetail.releaseDate,
                              style:
                                  Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: Colors.yellow[800],
                                        fontSize: 13,
                                        fontFamily: 'mulish',
                                      ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Duration'.toUpperCase(),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'mulish',
                                    fontSize: 13.0,
                                  ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${hours}h ${minutes}m',
                              style:
                                  Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: Colors.yellow[800],
                                        fontSize: 13,
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
                              style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'mulish',
                                  fontSize: 13.0),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              // movieDetail.budget,
                              finalFormattedBudget,
                              style:
                                  Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: Colors.yellow[800],
                                        fontSize: 13,
                                        fontFamily: 'mulish',
                                      ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'revenue'.toUpperCase(),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'mulish',
                                  fontSize: 13.0),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              finalFormattedRevenue,
                              style:
                                  Theme.of(context).textTheme.subtitle2.copyWith(
                                        color: Colors.yellow[800],
                                        fontSize: 13,
                                        fontFamily: 'mulish',
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Photos'.toUpperCase(),
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'mulish',
                            fontSize: 13.0,
                          ),
                    ),
                    SizedBox(height: 7),
                    Container(
                      height: 155,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const VerticalDivider(
                          color: Colors.transparent,
                          width: 5,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: movieDetail.movieImage.backdrops.length,
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
                                    placeholder: (context, url) => Center(
                                      child: Platform.isAndroid
                                          ? Padding(
                                              padding: EdgeInsets.all(150.0),
                                              child: LoadingIndicator(
                                                indicatorType:
                                                    Indicator.lineSpinFadeLoader,
                                              ),
                                            )
                                          : const CupertinoActivityIndicator(),
                                    ),
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                    fit: BoxFit.cover,
                                  ),
                                  onTap: () {
                                    int tappedIndex = movieDetail
                                        .movieImage.backdrops
                                        .indexOf(image);
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
                                                        PhotoViewGallery.builder(
                                                      itemCount: movieDetail
                                                          .movieImage
                                                          .backdrops
                                                          .length,
                                                      builder:
                                                          (BuildContext context,
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
                                                        color: Colors.black,
                                                      ),
                                                      pageController:
                                                          PageController(
                                                              initialPage:
                                                                  tappedIndex),
                                                      onPageChanged: (int index) {
                                                        setState(() {
                                                          _currentIndex = index;
                                                        });
                                                      },
                                                      enableRotation: true,
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
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 15),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Top Cast'.toUpperCase(),
                      style: Theme.of(context).textTheme.caption.copyWith(
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
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  elevation: 3,
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                      imageBuilder: (context, imageBuilder) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(100)),
                                            image: DecorationImage(
                                              image: imageBuilder,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                        width: 80,
                                        height: 80,
                                        child: Center(
                                          child: Platform.isAndroid
                                              ? const Padding(
                                                  padding: EdgeInsets.all(150.0),
                                                  child: LoadingIndicator(
                                                    indicatorType: Indicator
                                                        .lineSpinFadeLoader,
                                                  ),
                                                )
                                              : const CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 80,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/image_not_found.jpeg'),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  fontFamily: 'mulish',
                                ),
                            children: [
                              TextSpan(
                                text: 'Similar To '.toUpperCase(),
                              ),
                              TextSpan(
                                text: movieDetail.title.toUpperCase(),
                                style: TextStyle(
                                  color: Colors
                                      .orange, // Replace with the desired color
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 17.0,
                        ),
                        BlocBuilder<SimilarMovieBloc, SimilarMovieState>(
                          builder: (context, state) {
                            if (state is SimilarMovieLoading) {
                              return Center(
                                child: Platform.isAndroid
                                    ? const Padding(
                                        padding: EdgeInsets.all(150.0),
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineSpinFadeLoader,
                                        ),
                                      )
                                    : const CupertinoActivityIndicator(),
                              );
                            } else if (state is SimilarMovieLoaded) {
                              List<Movie> similarMovies = state.similarMovieList;
                              return SimilarMovieWidget(
                                  similarMovies: similarMovies);
                              // return SimilarTvSeriesWidget(: movieList);
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15.0,
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    BlocBuilder<MovieReviewBloc, MovieReviewState>(
                      builder: (context, state) {
                        if (state is MovieReviewLoading) {
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
                        } else if (state is MovieReviewLoaded) {
                          List<Review> movieReviewList = state.movieReviewList;
                          return MovieReviewWidget(
                              movieReviewList: movieReviewList);
                          // return SimilarTvSeriesWidget(: movieList);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                              ),
                        ),
                        SizedBox(
                          height: 17.0,
                        ),
                        BlocBuilder<RecommendedMovieBloc, RecommendedMovieState>(
                          builder: (context, state) {
                            if (state is RecommendedMovieLoading) {
                              return Center(
                                child: Platform.isAndroid
                                    ? const Padding(
                                        padding: EdgeInsets.all(150.0),
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineSpinFadeLoader,
                                        ),
                                      )
                                    : const CupertinoActivityIndicator(),
                              );
                            } else if (state is RecommendedMovieLoaded) {
                              List<Movie> recommendedMovies =
                                  state.recommendedMovieList;
                              return RecommendedMovieWidget(
                                  recommendedMovies: recommendedMovies);
                              // return SimilarTvSeriesWidget(: movieList);
                            } else {
                              return Container();
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Production Companies'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'mulish',
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 120.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movieDetail.productionCompanies.length,
                            itemBuilder: (context, index) {
                              final company =
                              movieDetail.productionCompanies[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    company.logoPath != null
                                        ? CachedNetworkImage(
                                      imageUrl:
                                      'https://image.tmdb.org/t/p/w500${company.logoPath}',
                                      width: 60,
                                      height: 60, color: Colors.white,
                                    )
                                        : SizedBox.shrink(),
                                    SizedBox(height: 8),
                                    Text(
                                      company.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
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
                  ],
                ),
              ),
            ),
          );
          // ],
          // );
        } else {
          return Container();
        }
      },
    );
  }
}
