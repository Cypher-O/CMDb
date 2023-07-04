import 'dart:io';
import 'package:CMDb/bloc/borntodaybloc/born_today_bloc.dart';
import 'package:CMDb/bloc/borntodaybloc/born_today_event.dart';
import 'package:CMDb/bloc/borntodaybloc/born_today_state.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/bloc/personbloc/person_bloc.dart';
import 'package:CMDb/bloc/personbloc/person_event.dart';
import 'package:CMDb/bloc/personbloc/person_state.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_event.dart';
import 'package:CMDb/bloc/tvshowbloc/tvshow_bloc_state.dart';
import 'package:CMDb/model/born_today.dart';
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/person.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/model/watch_list.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:CMDb/ui/bottom_nav_bar.dart';
import 'package:CMDb/ui/category_screen.dart';
import 'package:CMDb/ui/movie_detail_screen.dart';
import 'package:CMDb/ui/search_bar.dart';
import 'package:CMDb/ui/settings_screen.dart';
import 'package:CMDb/ui/watchlist_screen.dart';
import 'package:CMDb/widgets/bookmark_clipper.dart';
import 'package:CMDb/widgets/bookmark_painter.dart';
import 'package:CMDb/widgets/born_today_widget.dart';
import 'package:CMDb/widgets/glowing_text.dart';
import 'package:CMDb/widgets/search_widget_listviews.dart';
import 'package:CMDb/widgets/tvshow_list_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:CMDb/ui/discover_screen.dart';
import 'package:CMDb/ui/search_delegate.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  // final MovieSearchDelegate searchDelegate = MovieSearchDelegate();
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieSearchDelegate searchDelegate = MovieSearchDelegate();
  SearchWidgets searchWidgets;
  bool searchIconClicked = false;

  // int currentPage = 0;

  // final TvShow tvShow;
  final _apiService = ApiService();

  // final searchDelegate = MovieSearchDelegate();

  PageController _pageController;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DiscoverScreen(),
    WatchListScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // _searchController.text = _searchResults[index]['title'] ?? _searchResults[index]['name'];
      // selectedSearchIndex = -1; // Reset the selectedSearchIndex
      // _performSearch(_searchController.text);
    });
  }

  @override
  void initState() {
    super.initState();
    searchWidgets = SearchWidgets(context, setState);
    _pageController = PageController();
  }

  @override
  void dispose() {
    searchDelegate.searchController.dispose();
    searchDelegate.searchFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(const MovieEventStarted(0, '')),
        ),
        BlocProvider<TvShowBloc>(
          create: (_) => TvShowBloc()..add(const TvShowEventStarted(0, '')),
        ),
        BlocProvider<PersonBloc>(
          create: (_) => PersonBloc()..add(PersonEventStated()),
        ),
        BlocProvider<BornTodayBloc>(
          create: (_) => BornTodayBloc()..add(BornTodayEventStarted()),
        ),
      ],
      child: Scaffold(
        appBar: _selectedIndex == 0
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // leading: Icon(
                //   Icons.menu_rounded,
                //   color: Colors.white,
                // ),
                // title: Text(
                //   'cmdB'.toUpperCase(),
                //   style: Theme.of(context).textTheme.caption.copyWith(
                //         color: Colors.white,
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //         fontFamily: 'mulish',
                //       ),
                // ),
          title: GlowingText(),
                actions: [
                  Container(
                    child: IconButton(
                      icon: const Icon(Icons.search_rounded),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          searchIconClicked = !searchIconClicked;
                          searchDelegate.searchVisible = searchIconClicked;
                          if (!searchIconClicked) {
                            searchDelegate.searchController.clear();
                          }
                          // searchDelegate.searchVisible = !searchDelegate.searchVisible;
                        });
                      },
                    ),
                  ),
                ],
                bottom: searchDelegate.searchVisible
                    ? SearchBar(
                        onSearchTextChanged: (text) {
                          setState(() {
                            searchDelegate.updateSearchResults(text);
                          });
                        },
                        // onSearchTextChanged: searchDelegate.updateSearchResults,
                        onClearButtonPressed: () {
                          setState(() {
                            searchDelegate.searchController
                                .clear(); // Clear the search text
                            searchDelegate.searchResults =
                                []; // Clear the search results
                          });
                        },
                        onBackButtonPressed: () {
                          setState(() {
                            searchDelegate.searchVisible =
                                false; // Dispose of the bottom in the AppBar
                            searchDelegate.searchResults =
                                []; // Clear the search results
                          });
                        },
                      )
                    : null,
              )
            : null,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildBody(context),
            for (int i = 0; i < _widgetOptions.length; i++) _widgetOptions[i],
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTabChanged: _onItemTapped,
          // height: customNavigationBarHeight,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              searchDelegate.searchVisible
                  ? searchWidgets.buildSearchListView()
                  : searchWidgets.buildRecentSearchListView(),
              BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
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
                  } else if (state is MovieLoaded) {
                    List<Movie> movies = state.movieList;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider.builder(
                          itemCount: movies.length,
                          itemBuilder: (BuildContext context, int index) {
                            Movie movie = movies[index];
                            return GestureDetector(
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
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Platform
                                              .isAndroid
                                          ? Transform.scale(
                                              scale: 0.3,
                                              child: LoadingIndicator(
                                                indicatorType: Indicator
                                                    .lineSpinFadeLoader,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15,
                                      left: 15,
                                    ),
                                    child: Text(
                                      movie.title.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: 'mulish',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Consumer<WatchlistModel>(
                                      builder: (context, watchlistModel, child) {
                                        bool isAdded = watchlistModel.movieWatchlist.contains(movie);

                                        return GestureDetector(
                                          onTap: () {
                                            if (isAdded) {
                                              watchlistModel.removeFromWatchlist(movie);
                                            } else {
                                              watchlistModel.addToWatchlist(movie);
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
                                  ),],
                              ),
                            );
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            pauseAutoPlayOnTouch: true,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            // autoPlayCurve:
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 12,
                              ),
                              const BuildWidgetCategory(),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'top rated tv show'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'mulish',
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: <Widget>[
                                  BlocBuilder<TvShowBloc, TvShowState>(
                                    builder: (context, state) {
                                      if (state is TvShowLoading) {
                                        return Center(
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
                                        );
                                      } else if (state is TvShowLoaded) {
                                        List<TvShow> tvShows = state.tvShowList;
                                        // print(tvShows.length);
                                        return TvShowListWidget(
                                            tvShows: tvShows);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  BlocBuilder<BornTodayBloc, BornTodayState>(
                                    builder: (context, state) {
                                      if (state is BornTodayLoading) {
                                        return Center(
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
                                        );
                                      } else
                                      if (state is BornTodayLoaded) {
                                        // List<BornToday> bornToday =
                                        final List<BornToday> bornToday = state.bornTodayList;
                                        // final bornToday = state.bornTodayList;
                                        // print(tvShows.length);
                                        return BornTodayListWidget(
                                            bornToday: bornToday);
                                      } else if (state is BornTodayError) {
                                        return Center(
                                          child: Text(
                                              'Failed to fetch born today data.'),
                                        );
                                      } else {
                                        // BlocProvider.of<BornTodayBloc>(context)
                                        //     .add(BornTodayEventStarted());
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'People trending today'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'mulish',
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Column(
                                children: <Widget>[
                                  BlocBuilder<PersonBloc, PersonState>(
                                    builder: (context, state) {
                                      if (state is PersonLoading) {
                                        return const Center();
                                      } else if (state is PersonLoaded) {
                                        List<Person> personList =
                                            state.personList;
                                        // print(personList.length);
                                        return Container(
                                          height: 110,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: personList.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const VerticalDivider(
                                              color: Colors.transparent,
                                              width: 8,
                                            ),
                                            itemBuilder: (context, index) {
                                              Person person = personList[index];
                                              return Container(
                                                // margin: EdgeInsets.only(bottom: 100),
                                                child: Column(
                                                  children: <Widget>[
                                                    Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      elevation: 3,
                                                      child: ClipRRect(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              'https://image.tmdb.org/t/p/w500${person.profilePath}',
                                                          imageBuilder: (context,
                                                              imageProvider) {
                                                            return Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                                ),
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            width: 80,
                                                            height: 80,
                                                            child: Center(
                                                              child: Platform
                                                                      .isAndroid
                                                                  ? const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              50.0),
                                                                      child:
                                                                          LoadingIndicator(
                                                                        indicatorType:
                                                                            Indicator.lineSpinFadeLoader,
                                                                      ),
                                                                    )
                                                                  : const CupertinoActivityIndicator(),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration:
                                                                const BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'assets/images/image_not_found.jpeg',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Center(
                                                        child: Text(
                                                          person.name
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'mulish',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Center(
                                                        child: Text(
                                                          person
                                                              .knowForDepartment
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'mulish',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(top: 50, bottom: 50),
                      child: Center(
                        child: Column(
                          children: [
                            // child:
                            const Image(
                              image: AssetImage(
                                  'assets/images/page_not_found_no_internet_connection.jpg'),
                              // fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 17,
                              ),
                              label: const Text("Retry"),
                              onPressed: () {
                                _buildBody(context);
                                print("I have been clicked");
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                elevation: 15,
                                padding: const EdgeInsets.all(10.0),
                                fixedSize: const Size(100.0, 47.0),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: const StadiumBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // child: const Text('Something went wrong!!!'),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
