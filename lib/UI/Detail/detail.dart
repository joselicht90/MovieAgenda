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
        _deviceHeight = deviceHeight,
        super(key: key);

  final DetailBloc _bloc;
  final CachedNetworkImage _poster;
  final int _movieId;
  final double _deviceHeight;

  @override
  _DetailBodyState createState() =>
      _DetailBodyState(deviceHeight: _deviceHeight);
}

class _DetailBodyState extends State<DetailBody> {
  _DetailBodyState({@required deviceHeight})
      : _deviceHeight = deviceHeight * 0.4;
  double _deviceHeight;
  double _shaderHeight = 450;
  bool _isExpanded = false;
  double _opactity = 0;
  double _sigma;
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //widget._bloc.getImageFilter(0, 0);
    return BlocProvider(
      bloc: widget._bloc,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: widget._movieId.toString(),
            child: Stack(
              children: <Widget>[
                widget._poster,
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: _sigma, sigmaX: _sigma),
                  child: Container(color: Colors.transparent),
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
                        stops: [0.5, 0.9],
                      ),
                    ),
                  ),
                )
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
                  child: buildBodyScrollable(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align buildBodyScrollable(BuildContext context) {
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
                  stream: widget._bloc.streamMovieDetail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      MovieDetail movie = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: _opactity,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 1),
                                opacity: _opactity,
                                child: Text(
                                  movie.title,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Text(
                                    movie.releaseDate.year.toString(),
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        movie.voteAverage.toString(),
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15),
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
                            ),
                            Row(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Theme.of(context).accentColor),
                                      child: Text(
                                        e.name,
                                        style: TextStyle(
                                            color: Colors.grey.shade200),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
                  }),
              Container(
                height: 200,
                child: StreamBuilder<MovieCredits>(
                  stream: widget._bloc.streamMovieCredits,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      MovieCredits credits = snapshot.data;
                      List<Cast> cast = credits.cast;
                      return Container(
                        height: 150,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: cast.length,
                          itemBuilder: (context, index) => Column(
                            children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(10),
                                  height: 150,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color:
                                        DynamicTheme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0xFFf0f0f0)
                                            : Color(0xFF303030),
                                    borderRadius: BorderRadius.circular(7),
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
                                  child: cast[index].profilePath != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: widget._bloc.getPersonImage(
                                            cast[index].profilePath,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                        )),
                              Text(
                                cast[index].name,
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
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
    );
  }
}
