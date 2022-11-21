// To parse this JSON data, do
//
//     final recent = recentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Recent recentFromJson(String str) => Recent.fromJson(json.decode(str));

String recentToJson(Recent data) => json.encode(data.toJson());

class Recent {
    Recent({
       required this.currentPage,
       required this.hasNextPage,
       required this.results,
    });

    String currentPage;
    bool hasNextPage;
    List<Result> results;

    factory Recent.fromJson(Map<String, dynamic> json) => Recent(
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
       required this.episodeId,
       required this.episodeNumber,
       required this.title,
       required this.image,
       required this.url,
    });

    String id;
    String episodeId;
    int episodeNumber;
    String title;
    String image;
    String url;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        episodeId: json["episodeId"],
        episodeNumber: json["episodeNumber"],
        title: json["title"],
        image: json["image"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "episodeId": episodeId,
        "episodeNumber": episodeNumber,
        "title": title,
        "image": image,
        "url": url,
    };
}
