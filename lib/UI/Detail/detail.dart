import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/detail.dart';

class Detail extends StatefulWidget {
  final String imagePath;
  final int movieId;
  @override
  Detail({@required this.imagePath, @required this.movieId});
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final DetailBloc _bloc = DetailBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DetailBody(
            bloc: _bloc,
            posterPath: widget.imagePath,
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    Key key,
    @required DetailBloc bloc,
    @required String posterPath,
  })  : _bloc = bloc,
        _posterPath = posterPath,
        super(key: key);

  final DetailBloc _bloc;
  final String _posterPath;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[_bloc.getMovieImagePoster(_posterPath)],
      ),
    );
  }
}
