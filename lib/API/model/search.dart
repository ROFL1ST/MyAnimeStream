// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

String searchToJson(Search data) => json.encode(data.toJson());

class Search {
    Search({
        required this.currentPage,
        required this.hasNextPage,
        required this.results,
    });

    int currentPage;
    bool hasNextPage;
    List<Result> results;

    factory Search.fromJson(Map<String, dynamic> json) => Search(
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
        required this.url,
        required this.image,
        required this.releaseDate,
        required this.subOrDub,
    });

    String id;
    String title;
    String url;
    String image;
    String releaseDate;
    String subOrDub;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        image: json["image"],
        releaseDate: json["releaseDate"],
        subOrDub: json["subOrDub"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "image": image,
        "releaseDate": releaseDate,
        "subOrDub": subOrDub,
    };
}
