import 'package:CMDb/model/episode.dart';
import 'package:CMDb/model/season.dart';
import 'package:CMDb/service/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BuildEpisodeList extends StatefulWidget {
  final int showId;
  final Season selectedSeason;
  final VoidCallback toggleContainerVisibility;
  final bool isVisible;

  const BuildEpisodeList({Key key, this.showId, this.selectedSeason, this.toggleContainerVisibility, this.isVisible = false,}) : super(key: key);

  @override
  _BuildEpisodeListState createState() => _BuildEpisodeListState();
}

class _BuildEpisodeListState extends State<BuildEpisodeList> {
  List<Episode> episodes = [];
  bool isLoading = false;
  // bool isContainerVisible = true;

  @override
  void initState() {
    super.initState();
    if (widget.isVisible) {
      fetchEpisodes(widget.selectedSeason);
    }
  }


  void fetchEpisodes(Season selectedSeason) async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      List<Episode> fetchedEpisodes = await ApiService().getEpisodes(widget.showId, selectedSeason.seasonNumber);
      if (mounted) {
        setState(() {
          episodes = fetchedEpisodes;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch episodes: $e');
      setState(() {
        isLoading = false; // Hide loading indicator in case of error
      });
      // Handle the error
    }
  }

  @override
  void didUpdateWidget(BuildEpisodeList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSeason != oldWidget.selectedSeason) {
      fetchEpisodes(widget.selectedSeason);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) { // If isVisible is false, return an empty container
      return Container();
    } else if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(130.0),
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
          ),
        ),
      );
    } else if (episodes.isEmpty) {
      return Center(
        child: Text('No episodes found.'),
      );
    }else {
      return Container(
        height: 300,
        // height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          itemCount: episodes.length,
          itemBuilder: (BuildContext context, int index) {
            final episode = episodes[index];
            return ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CachedNetworkImage(
                imageUrl: episode.stillPath != null ? 'https://image.tmdb.org/t/p/w500${episode.stillPath}' : '',
                // imageUrl: 'https://image.tmdb.org/t/p/w200${episode.stillPath}',
                placeholder: (context, url) => LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              title: Text(episode.name),
              subtitle: Text('Episode ${episode.episodeNumber}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${episode.runtime} min'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 4),
                      // Adjust the spacing between the star icon and vote average
                      Text(
                        '${episode.voteAverage.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      );
    }
  }
}
