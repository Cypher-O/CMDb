import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc.dart';
import 'package:CMDb/bloc/movireviewbloc/movie_review_bloc_event.dart';
import 'package:CMDb/model/review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class MovieReviewWidget extends StatelessWidget {
  final List<Review> movieReviewList;

  MovieReviewWidget({this.movieReviewList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieReviewBloc>(
      create: (_) =>
          MovieReviewBloc()..add(const MovieReviewEventStarted(0, '')),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: movieReviewList.isEmpty
            ? Center(
          child: Text(
            'No reviews at the moment',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            :  ListView.builder(
          itemCount: movieReviewList.length,
          itemBuilder: (context, index) {
            Review review = movieReviewList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: review.authorImageUrl ?? '',
                              placeholder: (context, url) =>
                                  Icon(Icons.person, color: Colors.white),
                              errorWidget: (context, url, error) => Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 23.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${review.author}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Posted ${timeago.format(review.createdAt)}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 17.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          '${review.rating ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 17.0),
                Text(
                  review.content,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 50.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
