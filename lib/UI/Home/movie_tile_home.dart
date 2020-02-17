import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMovie.dart';
import 'package:movie_agenda/UI/Detail/detail.dart';

class MovieTileHome extends StatelessWidget {
  const MovieTileHome({
    Key key,
    @required HomeBloc bloc,
    @required this.movie,
  })  : _bloc = bloc,
        super(key: key);

  final HomeBloc _bloc;
  final UpcomingMovie movie;

  @override
  Widget build(BuildContext context) {
    CachedNetworkImage _poster = _bloc.getMovieImagePoster(movie.posterPath);
    //ExtendedImage _backdrop = movie.backdropPath != null ?_bloc.getMoviebackdrop(movie.backdropPath) : null;
    return InkWell(
      borderRadius: BorderRadius.circular(7),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Detail(posterImage: _poster, movieId: movie.id),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Hero(
          child: _poster,
          tag: movie.id.toString(),
        ),
      ),
    );
  }
}

class MovieTitle extends StatelessWidget {
  const MovieTitle({
    Key key,
    @required this.movie,
    @required Color tileTextColor,
  })  : _tileTextColor = tileTextColor,
        super(key: key);

  final UpcomingMovie movie;
  final Color _tileTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Text(
        movie.title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: _tileTextColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }
}
