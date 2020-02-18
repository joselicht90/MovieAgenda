import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/detail_bloc.dart';
import 'package:movie_agenda/DataLayer/models/MovieDetail.dart';
import 'package:movie_agenda/UI/Detail/cast_container.dart';

class ScrollableBody extends StatelessWidget {
  const ScrollableBody({
    Key key,
    @required DetailBloc bloc,
    @required double opactity,
  }) : _opactity = opactity, _bloc = bloc,super(key: key);

  final DetailBloc _bloc;
  final double _opactity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<MovieDetail>(
                stream: _bloc.streamMovieDetail,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    MovieDetail movie = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          OpacityTitle(opactity: _opactity, movie: movie),
                          ScoreAndYear(movie: movie),
                          Genres(movie: movie),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              movie.overview,
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              CastContainer(bloc: _bloc),
            ],
          ),
        ),
      ),
    );
  }
}

class Genres extends StatelessWidget {
  const Genres({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: movie.genres
          .map(
            (e) => Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 0.5),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor),
              child: Text(
                e.name,
                style: TextStyle(color: Colors.grey.shade200),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ScoreAndYear extends StatelessWidget {
  const ScoreAndYear({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(5),
          child: Text(
            movie.releaseDate.year.toString(),
            style: TextStyle(color: Colors.grey.shade200, fontSize: 15),
          ),
        ),
        SizedBox(
          height: 10,
          width: 1,
          child: Container(
            color: Colors.grey.shade200,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                movie.voteAverage.toString(),
                style: TextStyle(color: Colors.grey.shade200, fontSize: 15),
              ),
              Icon(
                Icons.star,
                color: Theme.of(context).accentColor,
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OpacityTitle extends StatelessWidget {
  const OpacityTitle({
    Key key,
    @required double opactity,
    @required this.movie,
  })  : _opactity = opactity,
        super(key: key);

  final double _opactity;
  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _opactity,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 1),
        opacity: _opactity,
        child: Text(
          movie.title,
          style: TextStyle(fontSize: 30, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}

