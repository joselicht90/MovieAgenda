import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/DataLayer/repository/repository.dart';

//BLOC DE PRODUCTO
class DetailBloc implements Bloc {
  final _controllerMovieDetail = StreamController<UpcomingMoviesResult>();


  Stream<UpcomingMoviesResult> get streamMovieDetail =>
      _controllerMovieDetail.stream;

  CachedNetworkImage getMovieImagePoster(String path){
    return Respository.getImageDetail(path);
  }


  @override
  void dispose() {
    _controllerMovieDetail.close();
  }
}
