import 'dart:io';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc.dart';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc_event.dart';
import 'package:CMDb/bloc/recommendedtvshowbloc/recommended_tvshow_bloc_state.dart';
import 'package:CMDb/bloc/similartvshowbloc/similar_tvshow_bloc.dart';
import 'package:CMDb/bloc/similartvshowbloc/similar_tvshow_bloc_event.dart';
import 'package:CMDb/bloc/similartvshowbloc/similar_tvshow_bloc_state.dart';
import 'package:CMDb/bloc/tvshowdetailbloc/tv_shows_detail_bloc.dart';
import 'package:CMDb/bloc/tvshowdetailbloc/tv_shows_detail_event.dart';
import 'package:CMDb/bloc/tvshowdetailbloc/tv_shows_detail_state.dart';
import 'package:CMDb/bloc/tvshowreviewbloc/tvshow_review_bloc.dart';
import 'package:CMDb/bloc/tvshowreviewbloc/tvshow_review_bloc_event.dart';
import 'package:CMDb/bloc/tvshowreviewbloc/tvshow_review_bloc_state.dart';
import 'package:CMDb/model/cast_list.dart';
import 'package:CMDb/model/review.dart';
import 'package:CMDb/model/screen_shot.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/tvshow_detail.dart';
import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:CMDb/ui/season_dropdown.dart';
import 'package:CMDb/widgets/bookmark_clipper.dart';
import 'package:CMDb/widgets/bookmark_painter.dart';
import 'package:CMDb/widgets/build_episode_list.dart';
import 'package:CMDb/widgets/recommended_tvshow_widget.dart';
import 'package:CMDb/widgets/review_tvshow_widget.dart';
import 'package:CMDb/widgets/similar_tvshow_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/episode.dart';
import '../model/genre.dart';
import '../model/season.dart';

class TvShowDetailScreen extends StatefulWidget {
  final TvShow tvShow;
  final int showId;
  final TvShowDetail tvShowDetail;

  const TvShowDetailScreen(
      {Key key, this.tvShow, this.showId, this.tvShowDetail})
      : super(key: key);

  @override
  State<TvShowDetailScreen> createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  GlobalKey _tooltipKey = GlobalKey();
  TvShowDetail tvShowDetail;
  final _apiService = ApiService();

  // final _buildEpisodeList = BuildEpisodeList();
  int _currentIndex = 0;
  final bool showMore = false;
  bool isContainerVisible = true;

  Season selectedSeason;
  List<Season> seasons = [];
  List<Episode> episodes = [];

  @override
  void initState() {
    super.initState();
    isContainerVisible = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the tooltip after a delay of 300 milliseconds
      // showTooltip();
      Future.delayed(Duration(milliseconds: 3000), showTooltip);
    });
  }

  void showTooltip() {
    final dynamic tooltip = _tooltipKey.currentState;
    if (tooltip != null && !isContainerVisible) {
      tooltip.ensureTooltipVisible();
    }
  }

  void toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TvShowDetailBloc()
            ..add(TvShowDetailEventStated(widget.tvShow.id,
                selectedSeason != null ? selectedSeason.seasonNumber : null)),
        ),
        BlocProvider<SimilarTvShowBloc>(
          create: (_) => SimilarTvShowBloc()
            ..add(SimilarTvShowEventStarted(widget.tvShow.id, '')),
        ),
        BlocProvider<RecommendedTvShowBloc>(
          create: (_) => RecommendedTvShowBloc()
            ..add(RecommendedTvShowEventStarted(widget.tvShow.id, '')),
        ),
        BlocProvider<TvShowReviewBloc>(
          create: (_) => TvShowReviewBloc()
            ..add(TvShowReviewEventStarted(widget.tvShow.id, '')),
        ),
      ],
      child: WillPopScope(
        child: Scaffold(
          body: _buildDetailBody(context),
        ),
        onWillPop: () async => true,
      ),
    );
  }

  Widget _buildDetailBody(BuildContext context) {
    return BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
      builder: (context, state) {
        if (state is TvShowDetailLoading) {
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
        } else if (state is TvShowDetailLoaded) {
          tvShowDetail = state.detail;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height / 2,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      FlexibleSpaceBar(
                        title: Text(
                          tvShowDetail.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'mulish',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        background: ClipPath(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${tvShowDetail.posterPath}',
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
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: Container(
                      //     height: 100,
                      //     width: 0.9,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.only(
                      //         bottomLeft: Radius.circular(50),
                      //         topLeft: Radius.circular(50),
                      //       ),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           offset: Offset(0, 5),
                      //           blurRadius: 50,
                      //           color: Color(0xFF12153D).withOpacity(0.2),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.add,
                      //               size: 30.0,
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
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
                                      'https://www.youtube.com/embed/${tvShowDetail.trailerId}';
                                  if (await canLaunch(youtubeUrl)) {
                                    await launch(youtubeUrl);
                                  }
                                },
                                // child: Center(
                                child: const Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.yellow,
                                  size: 65,
                                ),
                                // Text(
                                //   tvShowDetail.name.toUpperCase(),
                                //   style: const TextStyle(
                                //     color: Colors.white,
                                //     fontFamily: 'mulish',
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                      Consumer<WatchlistModel>(
                        builder: (context, watchlistModel, child) {
                          bool isAdded = watchlistModel.tvShowWatchlist.contains(widget.tvShow);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isAdded) {
                                  watchlistModel.removeFromWatchlistTvShow(widget.tvShow);
                                } else {
                                  watchlistModel.addToWatchlistTvShow(widget.tvShow);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                isAdded ? Icons.bookmark_added_rounded : Icons.bookmark_add_outlined,
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
                    Column(
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
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Column(
                        children: [
                          ReadMoreText(
                            tvShowDetail.overview,
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
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const VerticalDivider(
                          color: Colors.transparent,
                          width: 4,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: tvShowDetail.genres.length,
                        itemBuilder: (context, index) {
                          Genre genre = tvShowDetail.genres[index];
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Release date".toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'mulish',
                                        fontSize: 13.0,
                                      ),
                            ),
                            Text(
                              tvShowDetail.releaseDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                    color: Colors.yellow[800],
                                    fontSize: 13,
                                    fontFamily: 'mulish',
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Episode Guide'.toUpperCase(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                fontFamily: 'mulish',
                              ),
                        ),
                        GestureDetector(
                          onTap: () => toggleContainerVisibility(),
                          child: Tooltip(
                            key: _tooltipKey,
                            message: "View Episodes",
                            preferBelow: false,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Icon(
                              isContainerVisible
                                  ? Icons.arrow_circle_up_outlined
                                  : Icons.arrow_drop_down_circle_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 35,
                      child: SeasonDropdown(
                        showId: tvShowDetail.id,
                        seasons: tvShowDetail.seasons
                            .where((season) => season.seasonNumber != 0)
                            .toList(),
                        selectedSeason: selectedSeason ??
                            (tvShowDetail.seasons.isNotEmpty
                                ? tvShowDetail.seasons.firstWhere(
                                    (season) => season.seasonNumber != 0)
                                : null),
                        onChanged: (season) {
                          setState(() {
                            selectedSeason = season;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isContainerVisible)
                      BuildEpisodeList(
                        showId: tvShowDetail.id,
                        selectedSeason: selectedSeason ??
                            tvShowDetail.seasons.firstWhere(
                              (season) => season.seasonNumber != 0,
                              orElse: () => null,
                            ),
                        toggleContainerVisibility: toggleContainerVisibility,
                        isVisible: isContainerVisible,
                      ),
                    const SizedBox(
                      height: 10,
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
                        itemCount: tvShowDetail.tvShowImage.backdrops.length,
                        itemBuilder: (context, index) {
                          Screenshot image =
                              tvShowDetail.tvShowImage.backdrops[index];
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
                                          ? const Padding(
                                              padding: EdgeInsets.all(150.0),
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
                                    int tappedIndex = tvShowDetail
                                        .tvShowImage.backdrops
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
                                                    child: PhotoViewGallery
                                                        .builder(
                                                      itemCount: tvShowDetail
                                                          .tvShowImage
                                                          .backdrops
                                                          .length,
                                                      builder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return PhotoViewGalleryPageOptions(
                                                          imageProvider:
                                                              CachedNetworkImageProvider(
                                                            'https://image.tmdb.org/t/p/w500${tvShowDetail.tvShowImage.backdrops[index].imagePath}',
                                                          ),
                                                          heroAttributes:
                                                              PhotoViewHeroAttributes(
                                                            tag:
                                                                'image${tvShowDetail.tvShowImage.backdrops[index].imagePath}$index',
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
                    const SizedBox(height: 10),
                    Text(
                      'Cast & Crew'.toUpperCase(),
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
                        itemCount: tvShowDetail.castList.length,
                        itemBuilder: (context, index) {
                          Cast cast = tvShowDetail.castList[index];
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
                                      placeholder: (context, url) => Container(
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
                                text: tvShowDetail.name.toUpperCase(),
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
                        BlocBuilder<SimilarTvShowBloc, SimilarTvShowState>(
                          builder: (context, state) {
                            if (state is SimilarTvShowLoading) {
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
                            } else if (state is SimilarTvShowLoaded) {
                              List<TvShow> similarTvShows =
                                  state.similarTvShowList;
                              return SimilarTvSeriesWidget(
                                  similarTvShows: similarTvShows);
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
                    BlocBuilder<TvShowReviewBloc, TvShowReviewState>(
                      builder: (context, state) {
                        if (state is TvShowReviewLoading) {
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
                        } else if (state is TvShowReviewLoaded) {
                          List<Review> tvShowReviewList =
                              state.tvShowReviewList;
                          return TvShowReviewWidget(
                              tvShowReviewList: tvShowReviewList);
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
                        BlocBuilder<RecommendedTvShowBloc,
                            RecommendedTvShowState>(
                          builder: (context, state) {
                            if (state is RecommendedTvShowLoading) {
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
                            } else if (state is RecommendedTvShowLoaded) {
                              List<TvShow> recommendedTvShows =
                                  state.recommendedTvShowList;
                              return RecommendedTvSeriesWidget(
                                  recommendedTvShows: recommendedTvShows);
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
                                itemCount: tvShowDetail.productionCompanies.length,
                                itemBuilder: (context, index) {
                                  final company =
                                  tvShowDetail.productionCompanies[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        company.logoPath != null
                                            ?
                                        CachedNetworkImage(
                                          imageUrl:
                                          'https://image.tmdb.org/t/p/w500${company.logoPath}',
                                          width: 60,
                                          height: 60,
                                          color: Colors.white,
                                        )
                                            : Text("No image available"),
                                            // : SizedBox.shrink(),
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
                        // SizedBox(height: 20,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          // );
        } else {
          return Container();
        }
      },
    );
  }
}
