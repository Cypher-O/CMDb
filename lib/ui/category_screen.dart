import 'dart:io';
import 'package:CMDb/widgets/movie_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CMDb/bloc/genrebloc/genre_bloc.dart';
import 'package:CMDb/bloc/genrebloc/genre_event.dart';
import 'package:CMDb/bloc/genrebloc/genre_state.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_event.dart';
import 'package:CMDb/bloc/moviebloc/movie_bloc_state.dart';
import 'package:CMDb/model/genre.dart';
import 'package:CMDb/model/movie.dart';
import 'package:loading_indicator/loading_indicator.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;

  const BuildWidgetCategory({Key key, this.selectedGenre = 28})
      : super(key: key);

  @override
  BuildWidgetCategoryState createState() => BuildWidgetCategoryState();
}

class BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  int selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenreBloc>(
          create: (_) => GenreBloc()..add(const GenreEventStarted()),
        ),
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(selectedGenre, '')),
        ),
      ],
      child: _buildGenre(context),
    );
  }

  Widget _buildGenre(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        BlocBuilder<GenreBloc, GenreState>(
          builder: (context, state) {
            if (state is GenreLoading) {
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
            } else if (state is GenreLoaded) {
              List<Genre> genres = state.genreList;
              return Container(
                height: 45,
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const VerticalDivider(
                        color: Colors.transparent,
                        width: 4,
                      ),
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    Genre genre = genres[index];
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Genre genre = genres[index];
                              selectedGenre = genre.id;
                              context
                                  .read<MovieBloc>()
                                  .add(MovieEventStarted(selectedGenre, ''));
                            });
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
                              color: (genre.id == selectedGenre)
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                            child: Text(
                              genre.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: (genre.id == selectedGenre)
                                    ? Colors.black45
                                    : Colors.white,
                                fontFamily: 'mulish',
                              ),
                            ),
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
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          child: Text(
            'now playing'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'mulish',
            ),
          ),
        ),SizedBox(height: 10,),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return  Center(child: Platform.isAndroid
                  ? const Padding(
                padding: EdgeInsets.all(150.0),
                child: LoadingIndicator(
                  indicatorType: Indicator.lineSpinFadeLoader,
                ),
              )
                  : const CupertinoActivityIndicator(),);
            } else if (state is MovieLoaded) {
             List<Movie> movieList = state.movieList;
             return MovieListWidget(movieList: movieList);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
