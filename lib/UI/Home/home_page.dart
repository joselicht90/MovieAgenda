import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMovie.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/UI/Generics/context_button.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final HomeBloc _bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    Color _tileTextColor = DynamicTheme.of(context).brightness == Brightness.light ? Color(0xFF414141) : Color(0x70f9f6f7);
    _bloc.getUpcomingMoviesResult();
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'UPCOMING MOVIES',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      Container(
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
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(10),
                                        height: 340,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(-4, -3),
                                              color: Color(0x25f9f6f7),
                                              blurRadius: 5,
                                            ),
                                            BoxShadow(
                                                offset: Offset(4, 3),
                                                color: Color(0x30000000),
                                                blurRadius: 5,
                                                spreadRadius: 0.5),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: _bloc.getMovieImagePoster(
                                              movie.posterPath),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          movie.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: _tileTextColor,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ContextButton(),
            ],
          ),
        ),
      ),
    );
  }
}
