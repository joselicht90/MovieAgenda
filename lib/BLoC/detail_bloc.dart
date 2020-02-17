import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/DataLayer/models/MovieCredits.dart';
import 'package:movie_agenda/DataLayer/models/MovieDetail.dart';
import 'package:movie_agenda/DataLayer/repository/repository.dart';

//BLOC DE PRODUCTO
class DetailBloc implements Bloc {
  final _controllerMovieDetail = StreamController<MovieDetail>();
  final _controllerMovieCredits = StreamController<MovieCredits>();

  Stream<MovieDetail> get streamMovieDetail => _controllerMovieDetail.stream;

  Stream<MovieCredits> get streamMovieCredits => _controllerMovieCredits.stream;

  void getMovieDetail(int id) async {
    Map<String, dynamic> response = await Respository.getDetails(id);
    MovieDetail movieDetail = MovieDetail.fromJson(response);
    _controllerMovieDetail.sink.add(movieDetail);
  }

  void getCredits(int id) async {
    Map<String, dynamic> response = await Respository.getCredits(id);
    MovieCredits movieDetail = MovieCredits.fromJson(response);
    _controllerMovieCredits.sink.add(movieDetail);
  }

  CachedNetworkImage getPersonImage(String path){
    return Respository.getPersonImage(path);
  }

  @override
  void dispose() {
    _controllerMovieDetail.close();
    _controllerMovieCredits.close();
  }
}
