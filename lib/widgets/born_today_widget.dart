import 'package:CMDb/bloc/borntodaybloc/born_today_bloc.dart';
import 'package:CMDb/bloc/borntodaybloc/born_today_event.dart';
import 'package:CMDb/model/born_today.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BornTodayListWidget extends StatelessWidget {
  final List<BornToday> bornToday;

  BornTodayListWidget({Key key, this.bornToday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BornTodayBloc>(
      create: (_) => BornTodayBloc()..add(BornTodayEventStarted()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Born Today'.toUpperCase(),
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
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bornToday.length,
              itemBuilder: (context, index) {
                final birthday = bornToday[index];
                return Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IntrinsicWidth(
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 135,
                                // Set the desired width of the card
                                height: 3 / 4 * 200,
                                // Set the desired height of the card
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://image.tmdb.org/t/p/w200${birthday.profilePath}',
                                    fit: BoxFit.cover,
                                  ),
                                  // child: Image.network(
                                  //   'https://image.tmdb.org/t/p/w200${birthday.profilePath}',
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${birthday.name.split(' ').first} ${birthday.name.split(' ').last}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Age: ${birthday.age}',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
    );
  }
}
