import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/DataLayer/repository/repository.dart';

//BLOC DE PRODUCTO
class HomeBloc implements Bloc {
  final _controllerUpcomingMoviesResult =
      StreamController<UpcomingMoviesResult>();

  Stream<UpcomingMoviesResult> get streamUpcomingMoviesResult =>
      _controllerUpcomingMoviesResult.stream;

  void getUpcomingMoviesResult() async {
    Map<String, dynamic> response = await Respository.fetchUpcomingMovies();
    UpcomingMoviesResult upcomingMoviesResult =
        UpcomingMoviesResult.fromJson(response);
    _controllerUpcomingMoviesResult.sink.add(upcomingMoviesResult);
  }

  ExtendedImage getMovieImagePoster(String path){
    return Respository.getPoster(path);
  }

  @override
  void dispose() {
    _controllerUpcomingMoviesResult.close();
  }
}