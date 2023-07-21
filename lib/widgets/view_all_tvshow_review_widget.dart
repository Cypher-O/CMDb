import 'package:CMDb/model/review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewAllTvShowReviewWidget extends StatelessWidget {
  final List<Review> tvShowReviewList;

  const ViewAllTvShowReviewWidget({Key key, this.tvShowReviewList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfReviews = tvShowReviewList.length;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("User Reviews ($numberOfReviews)"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: tvShowReviewList.isEmpty
                    ? Center(
                        child: Text(
                          'No reviews at the moment',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                        itemCount: tvShowReviewList.length,
                        itemBuilder: (context, index) {
                          Review review = tvShowReviewList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0,), 
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                review.authorImageUrl ?? '',
                                            placeholder: (context, url) => Icon(
                                                Icons.person,
                                                color: Colors.white),
                                            errorWidget:
                                                (context, url, error) => Icon(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              SizedBox(height: 20.0),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(thickness: 2.0),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

