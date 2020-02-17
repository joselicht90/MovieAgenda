import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Respository {
  static String _apiKey = '253fdce6312504eaef3735b06cecbdf5';
  static String _imagesUrl = 'https://image.tmdb.org/t/p/w500';
  static String _personImageUrl = 'https://image.tmdb.org/t/p/w300';
  static String _originalImageUrl = 'https://image.tmdb.org/t/p/original';

  static Future<Map<String, dynamic>> fetchUpcomingMovies() async {
    String urlRequest =
        'http://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey&language=en-US&page=1&region=US';
    final response = await http.get(urlRequest);
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      throw Exception('Fetching Error');
  }

  static CachedNetworkImage getPoster(String path) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: _imagesUrl + path,
      placeholder: (context, url) => Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Future<Map<String, dynamic>> getDetails(int movieId) async {
    String urlRequest =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=en-US';
    final response = await http.get(urlRequest);
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      throw Exception('Fetching Error');
  }

  static Future<Map<String, dynamic>> getCredits(int movieId) async {
    String urlRequest =
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey';
    final response = await http.get(urlRequest);
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      throw Exception('Fetching Error');
  }

  static CachedNetworkImage getPersonImage(String path){
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: _personImageUrl+path,
      placeholder: (context, url) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.person, size: 50,),
    );
  }

  static CachedNetworkImage getImageDetail(String path){
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: _originalImageUrl+path,
      placeholder: (context, url) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 50),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

}
