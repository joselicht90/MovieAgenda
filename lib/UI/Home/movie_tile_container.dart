import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMovie.dart';
import 'package:movie_agenda/UI/Home/movie_tile_home.dart';

class MovieTileContainer extends StatelessWidget {
  const MovieTileContainer({
    Key key,
    @required HomeBloc bloc,
    @required this.movie,
  }) : _bloc = bloc, super(key: key);

  final HomeBloc _bloc;
  final UpcomingMovie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(10),
      height: 340,
      width: 200,
      decoration: BoxDecoration(
        color: DynamicTheme.of(context)
                    .brightness ==
                Brightness.light
            ? Color(0xFFf0f0f0)
            : Color(0xFF303030),
        borderRadius:
            BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            offset: Offset(-4, -4),
            color: DynamicTheme.of(context)
                        .brightness ==
                    Brightness.light
                ? Colors.white
                : Color(0xFF525252)
                    .withOpacity(0.2),
            blurRadius: 6,
          ),
          BoxShadow(
              offset: Offset(4, 4),
              color: Colors.black26,
              blurRadius: 6,
              spreadRadius: 0.5),
        ],
      ),
      child: MovieTileHome(bloc: _bloc, movie: movie),
    );
  }
}