import 'dart:io';

import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_event.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/ui/rating_widget.dart';
import 'package:CMDb/ui/search_bar.dart';
import 'package:CMDb/ui/search_delegate.dart';
import 'package:CMDb/ui/tv_detail_screen.dart';
import 'package:CMDb/ui/view_all.dart';
import 'package:CMDb/widgets/search_widget_listviews.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../bloc/moviebloc/movie_bloc.dart';
import '../bloc/moviebloc/movie_bloc_state.dart';
import '../bloc/tvshowbloc/tvshow_bloc.dart';
import '../bloc/tvshowbloc/tvshow_bloc_state.dart';
import 'home_screen.dart';
import 'movie_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final List<dynamic> popularMoviesList;
  final List<dynamic> topRatedMoviesList;
  final List<dynamic> trendingTvShowsList;

  const DiscoverScreen({
    Key key,
    this.popularMoviesList,
    this.topRatedMoviesList,
    this.trendingTvShowsList,
  }) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchWidgets = SearchWidgets(context, setState);
  }
  // final _homeScreen = HomeScreen();
  // HomeScreen get homeScreen => widget.homeScreen;
  SearchWidgets searchWidgets;
  final MovieSearchDelegate searchDelegate = MovieSearchDelegate();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) =>
          MovieBloc()
            ..add(const MovieEventStarted(0, '')),
        ),
        BlocProvider<TvShowBloc>(
          create: (_) =>
          TvShowBloc()
            ..add(const TvShowEventStarted(0, '')),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.account_circle_outlined),
          title: Text("Discover"),
          actions: [
            Container(
              child: IconButton(
                icon: const Icon(Icons.search_rounded),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    searchDelegate.searchVisible = !searchDelegate.searchVisible;
                  });
                },
              ),
            ),
          ],
          bottom: searchDelegate.searchVisible ? SearchBar(
            onSearchTextChanged:searchDelegate.updateSearchResults,
            onClearButtonPressed: () {
              setState(() {
                searchDelegate.searchController.clear(); // Clear the search text
                searchDelegate.searchResults = []; // Clear the search results
              });
            },
            onBackButtonPressed: () {// Go back to the previous screen
              setState(() {
                searchDelegate.searchVisible = false; // Dispose of the bottom in the AppBar
                searchDelegate.searchResults = []; // Clear the search results
              });
            },
          ) : null,
        ),
        body: IndexedStack(
          // height: double.infinity,
          children: [
            _buildBody(context),
          ],
        ),
        bottomNavigationBar: BottomAppBar(),
      ),
    );
  }
  Widget _buildBody (BuildContext context){
    return LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        // padding: EdgeInsets.all(16),
        child: Column(
          children: [
            searchDelegate.searchVisible
                ? searchWidgets.buildSearchListView()
                : searchWidgets.buildRecentSearchListView(),
            SectionTitle(
              'Popular Movies',
              MovieList(),
              widget.popularMoviesList,
            ),
            SectionTitle(
              'Top Rated Movies',
              TopRatedMovieList(),
              widget.topRatedMoviesList,
            ),
            SectionTitle(
              'Trending TV Shows',
              TvShowList(),
              widget.trendingTvShowsList,
            ),
          ],
        ),
      );
    }
    );
  }
}

class SectionTitle extends StatefulWidget {
  final String title;
  final Widget itemWidget;
  final List<dynamic> itemList;

  SectionTitle(this.title, this.itemWidget, this.itemList);

  @override
  State<SectionTitle> createState() => _SectionTitleState();
}

class _SectionTitleState extends State<SectionTitle> {
 bool viewAllSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllScreen(
                      itemWidget: widget.itemWidget,
                      title: widget.title,
                      itemList: widget.itemList,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1, // Set the number of items to 1
              itemBuilder: (BuildContext context, int index) {
                return widget.itemWidget;
              },
            ),
          ),
        ),
        // SingleChildScrollView(
        //   physics: NeverScrollableScrollPhysics(),
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     physics: NeverScrollableScrollPhysics(),
        //     itemCount: viewAllSelected ? widget.itemList.length : 5,
        //     itemBuilder: (BuildContext context, int index) {
        //       return widget.itemWidget;
        //     },
        //   ),
        // ),
        // if (!viewAllSelected && widget.itemList.length > 5)
        //   TextButton(
        //     onPressed: () {
        //       setState(() {
        //         viewAllSelected = true;
        //       });
        //     },
        //     child: Text(
        //       "View All",
        //       style: TextStyle(color: Colors.orange),
        //     ),
        //   ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final Movie movie;

  const MovieList({this.movie});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center();
        } else if (state is MovieLoaded) {
          List<Movie> movieList = state.movieList;

          return Container(
            height: 300,
            child: ListView.separated(
              separatorBuilder: (context, index) => const VerticalDivider(
                color: Colors.transparent,
                width: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: movieList.length > 5 ? 5 : movieList.length,
              itemBuilder: (context, index) {
                Movie movie = movieList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: "moviePoster${movie.id}",
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: 165,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                  width: 180,
                                  height: 250,
                                  child: Center(
                                    child: Platform.isAndroid
                                        ? Container(
                                            child: const LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballSpinFadeLoader,
                                            ),
                                            height: 15,
                                          )
                                        : const CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 180,
                                  height: 250,
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
                            top: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black26,
                              ),
                              child: const Icon(Icons.add, size: 30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 180,
                      child: Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mulish',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RatingWidget(
                            voteAverage: movie.voteAverage,
                            starSize: 14,
                            starColor: Colors.yellow,
                            emptyStarColor: Colors.grey,
                          ),
                          // Icon(
                          //   Icons.star,
                          //   color: Colors.yellow,
                          //   size: 14,
                          // ),
                          SizedBox(width: 4),
                          // Adjust the spacing between the icon and text
                          Text(
                            '${movie.voteAverage}\t/\t10',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class TopRatedMovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center();
        } else if (state is MovieLoaded) {
          List<Movie> movieList = state.topRatedMovieList;

          return Container(
            height: 300,
            child: ListView.separated(
              separatorBuilder: (context, index) => const VerticalDivider(
                color: Colors.transparent,
                width: 15,
              ),
              scrollDirection: Axis.horizontal,
              // itemCount: movieList.length,
              itemCount: movieList.length > 5 ? 5 : movieList.length,
              itemBuilder: (context, index) {
                Movie movie = movieList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movie: movie),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: "moviePoster${movie.id}",
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    width: 165,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                  width: 180,
                                  height: 250,
                                  child: Center(
                                    child: Platform.isAndroid
                                        ? Container(
                                            child: const LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballSpinFadeLoader,
                                            ),
                                            height: 15,
                                          )
                                        : const CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 180,
                                  height: 250,
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
                            top: 0,
                            left: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black26,
                              ),
                              child: const Icon(Icons.add, size: 30.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: 180,
                      child: Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'mulish',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RatingWidget(
                            voteAverage: movie.voteAverage,
                            starSize: 14,
                            starColor: Colors.yellow,
                            emptyStarColor: Colors.grey,
                          ),
                          // Icon(
                          //   Icons.star,
                          //   color: Colors.yellow,
                          //   size: 14,
                          // ),
                          SizedBox(width: 4),
                          // Adjust the spacing between the icon and text
                          Text(
                            '${movie.voteAverage}\t/\t10',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class TvShowList extends StatelessWidget {
  final TvShow tvShow;

  const TvShowList({Key key, this.tvShow}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvShowBloc, TvShowState>(
      builder: (context, state) {
        if (state is TvShowLoading) {
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
        } else {
          if (state is TvShowLoaded) {
            List<TvShow> tvShows = state.tvShowList;
            // print(tvShows.length);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const VerticalDivider(
                      color: Colors.transparent,
                      width: 15,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: tvShows.length > 5 ? 5 : tvShows.length,
                    itemBuilder: (context, index) {
                      TvShow tvShow = tvShows[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TvShowDetailScreen(tvShow: tvShow),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Hero(
                                  tag: "tvShowPoster${tvShow.id}",
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original/${tvShow.posterPath}',
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: 165,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                        width: 180,
                                        height: 250,
                                        child: Center(
                                          child: Platform.isAndroid
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
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 180,
                                        height: 250,
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
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black26,
                                    ),
                                    child: const Icon(Icons.add, size: 30.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: 180,
                            child: Text(
                              tvShow.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'mulish',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RatingWidget(
                                  voteAverage: tvShow.voteAverage,
                                  starSize: 14,
                                  starColor: Colors.yellow,
                                  emptyStarColor: Colors.grey,
                                ),
                                // Icon(
                                //   Icons.star,
                                //   color: Colors.yellow,
                                //   size: 14,
                                // ),
                                SizedBox(width: 4),
                                // Adjust the spacing between the icon and text
                                Text(
                                  '${tvShow.voteAverage}\t/\t10',
                                  style: TextStyle(
                                    color: Colors.white,
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
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
