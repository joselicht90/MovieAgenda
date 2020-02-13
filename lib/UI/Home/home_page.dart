import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/UI/Generics/context_button.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final HomeBloc _bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        height: 350,
                        child: StreamBuilder<UpcomingMoviesResult>(
                          stream: _bloc.streamUpcomingMoviesResult,
                          builder: (context, snapshot) {
                            UpcomingMoviesResult upcomingMoviesResult =
                                snapshot.data;
                            if (snapshot.hasData) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: upcomingMoviesResult.results.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.circular(7),
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
                                      borderRadius: BorderRadius.circular(7),
                                      child: _bloc.getMovieImagePoster(upcomingMoviesResult.results[index].posterPath),
                                    ),
                                    // child: Center(
                                    //   child: Text(
                                    //       '${upcomingMoviesResult.results[index].title}'),
                                    // ),
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
