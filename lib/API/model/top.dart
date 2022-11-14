// To parse this JSON data, do
//
//     final top = topFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Top topFromJson(String str) => Top.fromJson(json.decode(str));

String topToJson(Top data) => json.encode(data.toJson());

class Top {
    Top({
        required this.currentPage,
        required this.hasNextPage,
        required this.results,
    });

    int currentPage;
    bool hasNextPage;
    List<Result> results;

    factory Top.fromJson(Map<String, dynamic> json) => Top(
        currentPage: json["currentPage"],
        hasNextPage: json["hasNextPage"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        required this.id,
        required this.title,
        required this.image,
        required this.url,
        required this.genres,
    });

    String id;
    String title;
    String image;
    String url;
    List<String> genres;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        url: json["url"],
        genres: List<String>.from(json["genres"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "url": url,
        "genres": List<dynamic>.from(genres.map((x) => x)),
    };
}
