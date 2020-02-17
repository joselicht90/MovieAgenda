import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/DataLayer/models/UpcomingMoviesResult.dart';
import 'package:movie_agenda/DataLayer/repository/repository.dart';

//BLOC DE PRODUCTO
class DetailBloc implements Bloc {
  final _controllerMovieDetail = StreamController<UpcomingMoviesResult>();

  final _controllerDynamicBackground = StreamController<ImageFilter>();

  Stream<UpcomingMoviesResult> get streamMovieDetail =>
      _controllerMovieDetail.stream;
  Stream<ImageFilter> get streamDynamicBackground =>
      _controllerDynamicBackground.stream;

  CachedNetworkImage getMovieImagePoster(String path) {
    return Respository.getImageDetail(path);
  }

  void getImageFilter(double sigmaX, double sigmaY){
    _controllerDynamicBackground.sink.add(ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY));
  }

  @override
  void dispose() {
    _controllerMovieDetail.close();
    _controllerDynamicBackground.close();
  }
}
