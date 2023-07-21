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
import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:CMDb/widgets/recommended_movie_widgets.dart';
import 'package:CMDb/widgets/review_movie_widget.dart';
import 'package:CMDb/widgets/similar_movie_widgets.dart';
import 'package:CMDb/widgets/video_player_screen.dart';
import 'package:CMDb/widgets/view_all_movie_review_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

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

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;
  List<Review> movieReviewList;
  bool showMore = false;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          MovieDetailBloc()
            ..add(MovieDetailEventStated(widget.movie.id)),
        ),
        BlocProvider<SimilarMovieBloc>(
          create: (_) =>
          SimilarMovieBloc()
            ..add(SimilarMovieEventStarted(widget.movie.id, '')),
        ),
        BlocProvider<RecommendedMovieBloc>(
          create: (_) =>
          RecommendedMovieBloc()
            ..add(RecommendedMovieEventStarted(widget.movie.id, '')),
        ),
        BlocProvider<MovieReviewBloc>(
          create: (_) =>
          MovieReviewBloc()
            ..add(MovieReviewEventStarted(widget.movie.id, '')),
        ),
      ],
      child: WillPopScope(
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          body: SlideTransition(
            position: _animation,
            child: _buildDetailBody(context),
          ),
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
                  elevation: 0,
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
                  expandedHeight: MediaQuery
                      .of(context)
                      .size
                      .height / 2,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        title: Text(
                          movieDetail.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'mulish',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        background: ClipPath(
                          child: CachedNetworkImage(
                            imageUrl:
                            'https://image.tmdb.org/t/p/original/${movieDetail
                                .posterPath}',
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 2,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                            Platform.isAndroid
                                ? const Padding(
                              padding: EdgeInsets.all(150.0),
                              child: LoadingIndicator(
                                indicatorType:
                                Indicator.lineSpinFadeLoader,
                              ),
                            )
                                : const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                                Container(
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
                      Positioned(
                        top: 300,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  // int movieId = int.parse(movieDetail.id);
                                  // String videoUrls = await apiService.getYoutubeId(movieId);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPlayerScreen(
                                            videoUrl:
                                            'https://www.youtube.com/watch?v=${movieDetail
                                                .trailerId}',
                                          ),
                                    ),
                                  );
                                },
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
                  actions: [
                    Consumer<WatchlistModel>(
                      builder: (context, watchlistModel, child) {
                        bool isAdded = watchlistModel.movieWatchlist
                            .contains(widget.movie);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isAdded) {
                                watchlistModel
                                    .removeFromWatchlist(widget.movie);
                              } else {
                                watchlistModel.addToWatchlist(widget.movie);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              isAdded
                                  ? Icons.bookmark_added_rounded
                                  : Icons.bookmark_add_outlined,
                              color: isAdded ? Colors.orange : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          VerticalDivider(
                            thickness: 3.0,
                            width: 0.0,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Plot Summary'.toUpperCase(),
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ReadMoreText(
                            movieDetail.overview,
                            trimLines: showMore ? null : 2,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Read more',
                            trimExpandedText: ' Show less',
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'mulish',
                              // fontWeight: FontWeight.bold,
                              // color: Colors.black,
                            ),
                            moreStyle: const TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        VerticalDivider(
                          thickness: 3.0,
                          width: 0.0,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Genres'.toUpperCase(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            fontFamily: 'mulish',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.0),
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
                                    Radius.circular(25.0),
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: Text(
                                  genre.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.0,
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
                  SizedBox(height: 25.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                VerticalDivider(thickness: 3.0, width: 0.0, color: Colors.orange,),
                                SizedBox(width: 8.0),
                                Text(
                                  'Release date'.toUpperCase(),
                                  style:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'mulish',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height:7.0,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              movieDetail.releaseDate,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall
                                  .copyWith(
                                color: Colors.yellow[800],
                                fontSize: 13.0,
                                fontFamily: 'mulish',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Duration'.toUpperCase(),
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                .copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'mulish',
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            '${hours}h ${minutes}m',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall
                                .copyWith(
                              color: Colors.yellow[800],
                              fontSize: 13.0,
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                .copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'mulish',
                                fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            // movieDetail.budget,
                            finalFormattedBudget,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall
                                .copyWith(
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall
                                .copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'mulish',
                                fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 7.0,
                          ),
                          Text(
                            finalFormattedRevenue,
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall
                                .copyWith(
                              color: Colors.yellow[800],
                              fontSize: 13.0,
                              fontFamily: 'mulish',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        VerticalDivider(
                          thickness: 3.0,
                          width: 0.0,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Photos'.toUpperCase(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodySmall
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'mulish',
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Container(
                    height: 155,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                      const VerticalDivider(
                        color: Colors.transparent,
                        width: 5.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetail.movieImage.backdrops.length,
                      itemBuilder: (context, index) {
                        Screenshot image =
                        movieDetail.movieImage.backdrops[index];
                        return Container(
                          child: Card(
                            elevation: 3.0,
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
                                            ? Padding(
                                          padding: EdgeInsets.all(150.0),
                                          child: LoadingIndicator(
                                            indicatorType: Indicator
                                                .lineSpinFadeLoader,
                                          ),
                                        )
                                            : const CupertinoActivityIndicator(),
                                      ),
                                  imageUrl:
                                  'https://image.tmdb.org/t/p/w500/${image
                                      .imagePath}',
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  int tappedIndex = movieDetail
                                      .movieImage.backdrops
                                      .indexOf(image);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Scaffold(
                                            backgroundColor: Colors.black,
                                            body: Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    Expanded(
                                                      child: PhotoViewGallery
                                                          .builder(
                                                        itemCount: movieDetail
                                                            .movieImage
                                                            .backdrops
                                                            .length,
                                                        builder:
                                                            (
                                                            BuildContext context,
                                                            int index) {
                                                          return PhotoViewGalleryPageOptions(
                                                            imageProvider:
                                                            CachedNetworkImageProvider(
                                                              // movieDetail.movieImage.backdrops[index]?.imagePath != null
                                                              //     ? 'https://image.tmdb.org/t/p/original/${movieDetail.movieImage.backdrops[index].imagePath}'
                                                              //     : 'assets/images/image_not_found.jpeg',
                                                              'https://image.tmdb.org/t/p/original${movieDetail
                                                                  .movieImage
                                                                  .backdrops[index]
                                                                  .imagePath}',
                                                            ),
                                                            heroAttributes:
                                                            PhotoViewHeroAttributes(
                                                              tag:
                                                              'image${movieDetail
                                                                  .movieImage
                                                                  .backdrops[index]
                                                                  .imagePath}',
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
                                                        onPageChanged:
                                                            (int index) {
                                                          setState(() {
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
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
                  const SizedBox(height: 25.0),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        VerticalDivider(thickness: 3.0, width: 0.0, color: Colors.orange,),
                        SizedBox(width: 8.0),
                        Text(
                          'Cast & Crew'.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'mulish',
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.0,),
                  Container(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                      const VerticalDivider(
                        color: Colors.transparent,
                        width: 5.0,
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
                                elevation: 3.0,
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    'https://image.tmdb.org/t/p/w500/${cast
                                        .profilePath}',
                                    imageBuilder: (context, imageBuilder) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(100)),
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
                                              EdgeInsets.all(150.0),
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
                    height: 25.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              VerticalDivider(thickness: 3.0, width: 0.0, color: Colors.orange),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodySmall.copyWith(
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
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 7.0),
                      BlocBuilder<SimilarMovieBloc, SimilarMovieState>(
                        builder: (context, state) {
                          if (state is SimilarMovieLoading) {
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
                          } else if (state is SimilarMovieLoaded) {
                            List<Movie> similarMovies = state.similarMovieList;
                            return SimilarMovieWidget(similarMovies: similarMovies);
                            // return SimilarTvSeriesWidget(movieList);
                          } else {
                            return Container();
                          }
                        },
                      ),
                      // SizedBox(height: 10.0),
                    ],
                  ),

                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     RichText(
                  //       overflow: TextOverflow.ellipsis,
                  //       text: TextSpan(
                  //         style: Theme
                  //             .of(context)
                  //             .textTheme
                  //             .bodySmall
                  //             .copyWith(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15.0,
                  //           fontFamily: 'mulish',
                  //         ),
                  //         children: [
                  //           TextSpan(
                  //             text: 'Similar To '.toUpperCase(),
                  //           ),
                  //           TextSpan(
                  //             text: movieDetail.title.toUpperCase(),
                  //             style: TextStyle(
                  //               color: Colors
                  //                   .orange,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       height: 7.0,
                  //     ),
                  //     BlocBuilder<SimilarMovieBloc, SimilarMovieState>(
                  //       builder: (context, state) {
                  //         if (state is SimilarMovieLoading) {
                  //           return Center(
                  //             child: Platform.isAndroid
                  //                 ? const Padding(
                  //               padding: EdgeInsets.all(150.0),
                  //               child: LoadingIndicator(
                  //                 indicatorType:
                  //                 Indicator.lineSpinFadeLoader,
                  //               ),
                  //             )
                  //                 : const CupertinoActivityIndicator(),
                  //           );
                  //         } else if (state is SimilarMovieLoaded) {
                  //           List<Movie> similarMovies =
                  //               state.similarMovieList;
                  //           return SimilarMovieWidget(
                  //               similarMovies: similarMovies);
                  //           // return SimilarTvSeriesWidget(: movieList);
                  //         } else {
                  //           return Container();
                  //         }
                  //       },
                  //     ),
                  //     // SizedBox(
                  //     //   height: 10.0,
                  //     // ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            VerticalDivider(
                              thickness: 3.0,
                              width: 0.0,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              "Reviews".toUpperCase(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                              ),
                            ),
                          ],
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewAllMovieReviewWidget(
                                      movieReviewList: movieReviewList),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  BlocBuilder<MovieReviewBloc, MovieReviewState>(
                    builder: (context, state) {
                      if (state is MovieReviewLoading) {
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
                      } else if (state is MovieReviewLoaded) {
                        movieReviewList = state.movieReviewList;
                        return MovieReviewWidget(
                            movieReviewList: movieReviewList);
                        // return SimilarTvSeriesWidget(: movieList);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            VerticalDivider(thickness: 3.0, width: 0.0, color: Colors.orange,),
                            SizedBox(width: 8.0),
                            Text(
                              'Recommended'.toUpperCase(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      BlocBuilder<RecommendedMovieBloc,
                          RecommendedMovieState>(
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
                        height: 25.0,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            VerticalDivider(thickness: 3.0, width: 0.0, color: Colors.orange,),
                            SizedBox(width: 8.0),
                            Text(
                              'Production Companies'.toUpperCase(),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 7.0),
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
                                    'https://image.tmdb.org/t/p/w500/${company
                                        .logoPath}',
                                    width: 60,
                                    height: 60,
                                    color: Colors.white,
                                  )
                                      : SizedBox.shrink(),
                                  SizedBox(height: 7.0),
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
