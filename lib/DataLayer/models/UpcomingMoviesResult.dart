// To parse this JSON data, do
//
//     final upcomingMoviesResult = upcomingMoviesResultFromJson(jsonString);

import 'dart:convert';

import 'package:movie_agenda/DataLayer/models/UpcomingMovie.dart';

UpcomingMoviesResult upcomingMoviesResultFromJson(String str) => UpcomingMoviesResult.fromJson(json.decode(str));

String upcomingMoviesResultToJson(UpcomingMoviesResult data) => json.encode(data.toJson());

class UpcomingMoviesResult {
    List<UpcomingMovie> results;
    int page;
    int totalResults;
    Dates dates;
    int totalPages;

    UpcomingMoviesResult({
        this.results,
        this.page,
        this.totalResults,
        this.dates,
        this.totalPages,
    });

    factory UpcomingMoviesResult.fromJson(Map<String, dynamic> json) => UpcomingMoviesResult(
        results: List<UpcomingMovie>.from(json["results"].map((x) => UpcomingMovie.fromJson(x))),
        page: json["page"],
        totalResults: json["total_results"],
        dates: Dates.fromJson(json["dates"]),
        totalPages: json["total_pages"],
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
        "total_results": totalResults,
        "dates": dates.toJson(),
        "total_pages": totalPages,
    };
}

class Dates {
    DateTime maximum;
    DateTime minimum;

    Dates({
        this.maximum,
        this.minimum,
    });

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );

    Map<String, dynamic> toJson() => {
        "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
        "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
    };
}




