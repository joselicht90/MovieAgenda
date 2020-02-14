import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/UI/Home/upcoming_movie_list.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key key,
    @required HomeBloc bloc,
    @required Color tileTextColor,
  })  : _bloc = bloc,
        _tileTextColor = tileTextColor,
        super(key: key);

  final HomeBloc _bloc;
  final Color _tileTextColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'UPCOMING MOVIES',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            UpcomingMoviesList(bloc: _bloc, tileTextColor: _tileTextColor),
          ],
        ),
      ),
    );
  }
}
