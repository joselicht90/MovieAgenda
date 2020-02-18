import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_agenda/BLoC/detail_bloc.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/DataLayer/models/MovieCredits.dart';
import 'package:movie_agenda/DataLayer/models/MovieDetail.dart';
import 'package:movie_agenda/UI/Detail/scrollable_body.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  getInfo() async {
    _bloc.getMovieDetail(widget.movieId);
    _bloc.getCredits(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DetailBody(
            deviceHeight: MediaQuery.of(context).size.height,
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
    @required double deviceHeight,
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
  _DetailBodyState createState() =>
      _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  double _shaderHeight = 450;
  double _opactity = 0;
  double _sigma;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: widget._bloc,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: widget._movieId.toString(),
            child: Stack(
              children: <Widget>[
                widget._poster,
                BackdropFilterFrost(sigma: _sigma),
                GreyShade(shaderHeight: _shaderHeight)
              ],
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is DraggableScrollableNotification) {
                print(scrollNotification.extent);
                setState(() {
                  if (scrollNotification.extent ==
                      scrollNotification.minExtent) {
                    _sigma = 0;
                    _opactity = 0;
                  } else {
                    _sigma = scrollNotification.extent * 1.2;
                    _opactity = scrollNotification.extent;
                  }
                });
              }
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              maxChildSize: 1,
              minChildSize: 0.4,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Theme.of(context).canvasColor, Colors.transparent],
                    stops: [0.3, 1],
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: ScrollableBody(bloc: widget._bloc, opactity: _opactity),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackdropFilterFrost extends StatelessWidget {
  const BackdropFilterFrost({
    Key key,
    @required double sigma,
  }) : _sigma = sigma, super(key: key);

  final double _sigma;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: _sigma, sigmaX: _sigma),
      child: Container(color: Colors.transparent),
    );
  }
}

class GreyShade extends StatelessWidget {
  const GreyShade({
    Key key,
    @required double shaderHeight,
  }) : _shaderHeight = shaderHeight, super(key: key);

  final double _shaderHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
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
            stops: [0.5, 0.9],
          ),
        ),
      ),
    );
  }
}




