
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMovie.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/UI/Home/movie_tile_container.dart';
import 'package:movie_agenda/UI/Home/movie_tile_home.dart';

class UpcomingMoviesList extends StatelessWidget {
  const UpcomingMoviesList({
    Key key,
    @required HomeBloc bloc,
    @required Color tileTextColor,
  }) : _bloc = bloc, _tileTextColor = tileTextColor, super(key: key);

  final HomeBloc _bloc;
  final Color _tileTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: StreamBuilder<UpcomingMoviesResult>(
        stream: _bloc.streamUpcomingMoviesResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UpcomingMoviesResult upcomingMoviesResult =
                snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: upcomingMoviesResult.results.length,
              itemBuilder: (context, index) {
                UpcomingMovie movie =
                    upcomingMoviesResult.results[index];
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MovieTileContainer(bloc: _bloc, movie: movie),
                    MovieTitle(movie: movie, tileTextColor: _tileTextColor),
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
