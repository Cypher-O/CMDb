
import 'package:CMDb/model/movie.dart';
import 'package:CMDb/model/tvshow.dart';
import 'package:CMDb/ui/movie_detail_screen.dart';
import 'package:CMDb/ui/recent_search_handler.dart';
import 'package:CMDb/ui/search_delegate.dart';
import 'package:CMDb/ui/tv_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SearchWidgets {
  final MovieSearchDelegate searchDelegate = MovieSearchDelegate();
  final BuildContext context;
  final Function setState;

  SearchWidgets(this.context, this.setState);

  Future<void> saveSearchItem(dynamic searchItem) async {
    // await RecentSearchHandler.addRecentSearch(searchItem);
    await RecentSearchHandler.addRecentSearchTile(searchItem);
  }

  Future<List<dynamic>> getRecentSearches() async {
    return await RecentSearchHandler.getRecentSearches();
  }

  Widget buildRecentSearchListView() {
    // if ((searchDelegate.searchVisible && searchDelegate.showRecentSearches) ||
    //     (searchDelegate.searchVisible && searchDelegate.searchController.text.isEmpty) ||
    // (searchDelegate.searchResults.isEmpty && searchDelegate.searchController.text.isEmpty)) {
    if (searchDelegate.searchVisible &&
        searchDelegate.searchController.text.isEmpty ||
        searchDelegate.searchResults.isEmpty &&
            searchDelegate.showRecentSearches) {
      return FutureBuilder<List<Map<String, dynamic>>>(
          future: RecentSearchHandler.getRecentSearches(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // } else
            if (snapshot.hasData) {
              final recentSearches = snapshot.data.reversed.toList();
              // Remove duplicates and move existing search to the top
              final updatedSearches = <Map<String, dynamic>>[];
              final Set<String> addedTitles = Set<String>();
              for (final searchItem in recentSearches) {
                final title = searchItem['title'] ?? searchItem['name'] ??
                    'No Title';
                if (!addedTitles.contains(title)) {
                  updatedSearches.add(searchItem);
                  addedTitles.add(title);
                }
              }
              // print('Recent Searches: $recentSearches');
              // print('Length: ${recentSearches.length}');
              return Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height - 200,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Search',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.clear, size: 15,),
                              onPressed: () {
                                // Clear recent searches
                                RecentSearchHandler.clearRecentSearches();
                                setState(() {
                                  // Update the UI to reflect the cleared searches
                                  recentSearches.clear();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: recentSearches.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          final searchItem = recentSearches[index];
                          final imageUrl = 'https://image.tmdb.org/t/p/w500${searchItem['poster_path']}';
                          final title = searchItem['title'] ??
                              searchItem['name'] ?? 'No Title';
                          final voteAverage = searchItem['vote_average']
                              .toStringAsFixed(1)
                              ?? '-';
                          final subtitle = searchItem['release_date'] ??
                              searchItem['first_air_date'];
                          final year = subtitle != null ? (DateTime
                              .tryParse(subtitle)
                              ?.year ?? '').toString() : '';
                          // Check if the imageUrl is a valid URL
                          if (imageUrl != null && imageUrl.isNotEmpty) {
                            // Build the ListTile using the saved searchItem data
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) {
                                // Remove the searchItem from the recentSearches list
                                setState(() {
                                  recentSearches.removeAt(index);
                                });
                                // Remove the searchItem from shared preferences
                                RecentSearchHandler.removeRecentSearch(
                                    searchItem);

                                if (recentSearches.isEmpty) {
                                  searchDelegate.showRecentSearches = true;
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                    leading: imageUrl != null
                                        ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      placeholder: (context, url) =>
                                          LoadingIndicator(
                                              indicatorType: Indicator
                                                  .lineSpinFadeLoader),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                        : Image.asset(
                                        'assets/images/page_not_found_no_internet_connection.jpg'),
                                    title: Text(
                                      title, overflow: TextOverflow.ellipsis,),
                                    subtitle: Text(year),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, color: Colors.yellow,
                                            size: 17),
                                        SizedBox(width: 5),
                                        Text('$voteAverage'),
                                      ],
                                    ),
                                    onTap: () async {
                                      if (searchItem['media_type'] == 'movie') {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                    movie: Movie.fromJson(
                                                        searchItem),
                                                  ),
                                            ));
                                      } else
                                      if (searchItem['media_type'] == 'tv') {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TvShowDetailScreen(
                                                    tvShow: TvShow.fromJson(
                                                        searchItem),
                                                  ),
                                            ));
                                      }
                                    }
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            } else {
              return SizedBox();
            }
          }
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildSearchListView() {
    if (searchDelegate.searchVisible &&
        searchDelegate.searchResults.isNotEmpty) {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height - 200,
        child: ListView.separated(
          itemCount: searchDelegate.searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            final searchResult = searchDelegate.searchResults[index];
            final title = searchResult['title'] ?? searchResult['name'];
            final rating = searchResult['vote_average'] != null
                ? searchResult['vote_average'].toStringAsFixed(1)
                : '-';
            final subtitle = searchResult['release_date'] ??
                searchResult['first_air_date'];
            final year = subtitle != null ? (DateTime
                .tryParse(subtitle)
                ?.year ?? '').toString() : '';
            final imageUrl = searchResult['poster_path'] != null
                ? "https://image.tmdb.org/t/p/w500${searchResult['poster_path']}"
                : '';

            if (imageUrl.isEmpty) {
              return SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  title ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(year ?? ''),
                leading: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 17),
                    SizedBox(width: 5),
                    Text(rating ?? ''),
                  ],
                ),
                onTap: () async {
                  await saveSearchItem(searchResult);
                  if (searchResult['media_type'] == 'movie') {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(
                            movie: Movie.fromJson(searchResult),
                          ),
                    ));
                  } else if (searchResult['media_type'] == 'tv') {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          TvShowDetailScreen(
                            tvShow: TvShow.fromJson(searchResult),
                          ),
                    ));
                  }
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            final searchResult = searchDelegate.searchResults[index];
            final imageUrl = searchResult['poster_path'] != null
                ? "https://image.tmdb.org/t/p/w500${searchResult['poster_path']}"
                : '';

            return imageUrl.isNotEmpty ? Divider() : SizedBox.shrink();
          },
        ),
      );
    } else if (searchDelegate.searchVisible &&
        searchDelegate.searchResults.isEmpty &&
        searchDelegate.searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 40, color: Colors.purple),
        ),
      );
    } else if (searchDelegate.showRecentSearches ||
        (searchDelegate.searchResults.isEmpty &&
            searchDelegate.searchController.text.isEmpty)) {
      return buildRecentSearchListView();
    } else {
      return Container();
    }
  }
}

//   Widget buildSearchListView() {
//     if (searchDelegate.searchVisible &&
//         searchDelegate.searchResults.isNotEmpty && !searchDelegate.showRecentSearches) {
//       return Container(
//         height: MediaQuery
//             .of(context)
//             .size
//             .height - 200,
//         child: searchDelegate.searchResults.isNotEmpty
//             ?  ListView.separated(
//           itemCount: searchDelegate.searchResults.length,
//           itemBuilder: (BuildContext context, int index) {
//             final searchResult = searchDelegate.searchResults[index];
//             final title = searchResult['title'] ?? searchResult['name'];
//             final rating = searchResult['vote_average'] != null
//                 ? searchResult['vote_average'].toStringAsFixed(1)
//                 : '-';
//             final subtitle = searchResult['release_date'] ??
//                 searchResult['first_air_date'];
//             final year = subtitle != null ? (DateTime
//                 .tryParse(subtitle)
//                 ?.year ?? '').toString() : '';
//             final imageUrl = searchResult['poster_path'] != null
//                 ? "https://image.tmdb.org/t/p/w500${searchResult['poster_path']}"
//                 : '';
//
//             if (imageUrl.isEmpty) {
//               return SizedBox.shrink();
//             }
//
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListTile(
//                 title: Text(
//                   title ?? '',
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 subtitle: Text(year ?? ''),
//                 leading: CachedNetworkImage(
//                   imageUrl: imageUrl,
//                   placeholder: (context, url) =>
//                       LoadingIndicator(
//                         indicatorType: Indicator.lineSpinFadeLoader,
//                       ),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.star, color: Colors.yellow, size: 17),
//                     SizedBox(width: 5),
//                     Text(rating ?? ''),
//                   ],
//                 ),
//                 onTap: () async {
//                   await saveSearchItem(searchResult);
//                   // await saveSearchItem(searchDelegate.searchResults[index]);
//                   if (searchResult['media_type'] == 'movie') {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) =>
//                           MovieDetailScreen(
//                             movie: Movie.fromJson(searchResult),
//                           ),
//                     ));
//                   } else if (searchResult['media_type'] == 'tv') {
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) =>
//                           TvShowDetailScreen(
//                             tvShow: TvShow.fromJson(searchResult),
//                           ),
//                     ));
//                   }
//                 },
//               ),
//             );
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             final searchResult = searchDelegate.searchResults[index];
//             final imageUrl = searchResult['poster_path'] != null
//                 ? "https://image.tmdb.org/t/p/w500${searchResult['poster_path']}"
//                 : '';
//
//             return imageUrl.isNotEmpty ? Divider() : SizedBox.shrink();
//           },
//         ) : Center(
//           child: Text('No results found', style: TextStyle(fontSize: 40, color: Colors.purple)),
//     ),
//       );
//     }
//     else if (searchDelegate.searchVisible ||
//         searchDelegate.searchResults.isEmpty) {
//       return buildRecentSearchListView();
//     }
//     else {
//       return Container();
//     }
//   }
// }