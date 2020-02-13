import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Respository {
  static String _apiKey = '253fdce6312504eaef3735b06cecbdf5';
  static String _apiReadAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNTNmZGNlNjMxMjUwNGVhZWYzNzM1YjA2Y2VjYmRmNSIsInN1YiI6IjVlNDNmY2Q1M2RkMTI2MDAxNjU5N2RjNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9kaBv0_STnBn7BHK0JVYh_V30N5EgRAB60g_tQ4Cceo';
  static String _imagesUrl = 'https://image.tmdb.org/t/p/w500';

  static Future<Map<String, dynamic>> fetchUpcomingMovies() async {
    String urlRequest =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey&language=en-US&page=1&region=US';
    final response = await http.get(urlRequest);
    if (response.statusCode == 200)
      return json.decode(response.body);
    else
      throw Exception('Fetching Error');
  }

  static ExtendedImage getPoster(String path) {
    return ExtendedImage.network(
      _imagesUrl + path,
      fit: BoxFit.fill,
      borderRadius: BorderRadius.circular(7),
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              height: 350,
              width: 200,
              fit: BoxFit.fill,
            );
          default:
            throw Exception();
        }
      },
    );
  }
}
