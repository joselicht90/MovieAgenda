import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/detail_bloc.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';

class Detail extends StatefulWidget {
  final CachedNetworkImage posterImage;
  final int movieId;
  @override
  Detail({@required this.posterImage, @required this.movieId});
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
            movieId: widget.movieId,
            bloc: _bloc,
            poster: widget.posterImage,
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatefulWidget {
  const DetailBody({
    Key key,
    @required DetailBloc bloc,
    @required int movieId,
    @required CachedNetworkImage poster,
  })  : _bloc = bloc,
        _poster = poster,
        _movieId = movieId,
        super(key: key);

  final DetailBloc _bloc;
  final CachedNetworkImage _poster;
  final int _movieId;

  @override
  _DetailBodyState createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  double _shaderHeight = 450;
  bool _isExpanded = false;
  double _opactity = 0;
  String _buttonText = 'Expand';
  @override
  Widget build(BuildContext context) {
    widget._bloc.getImageFilter(0, 0);
    return Stack(
      children: <Widget>[
        Hero(
          tag: widget._movieId.toString(),
          child: Stack(
            children: <Widget>[
              widget._poster,
              AnimatedOpacity(
                duration: Duration(milliseconds: 1),
                opacity: _opactity,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  height: _shaderHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).canvasColor,
                          Colors.transparent
                        ],
                        stops: [
                          0.5,
                          0.9
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
        DraggableScrollableSheet(
          builder: (context, _scrollController) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: SafeArea(
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            if (_isExpanded) {
                              _shaderHeight = 450;
                              _buttonText = 'Expand';
                              _opactity = 0;
                            } else {
                              _shaderHeight = 1000;
                              _buttonText = 'Collapse';
                              _opactity = 1;
                            }
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(_buttonText))),
              ),
            );
          },
          initialChildSize: 0.3,
          maxChildSize: 1,
          minChildSize: 0.3,
        )
      ],
    );
  }
}

class DynamicBackground extends StatelessWidget {
  const DynamicBackground({
    Key key,
    @required String posterPath,
    @required DetailBloc bloc,
  })  : _posterPath = posterPath,
        _bloc = bloc,
        super(key: key);

  final String _posterPath;
  final DetailBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _bloc,
      child: StreamBuilder(
          stream: _bloc.streamDynamicBackground,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  Container(
                    child: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).canvasColor,
                            Colors.transparent
                          ],
                          stops: [0.5, 0.9],
                        ).createShader(bounds);
                      },
                      child: _bloc.getMovieImagePoster(_posterPath),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: BackdropFilter(
                      filter: snapshot.data,
                      child: Center(
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}

// BackdropFilter(
//   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//   child: Center(
//     child: Container(
//       color: Colors.transparent,
//     ),
//   ),
// ),
