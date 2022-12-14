// To parse this JSON data, do
//
//     final recentAnime = recentAnimeFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RecentAnime recentAnimeFromJson(String str) =>
    RecentAnime.fromJson(json.decode(str));

String recentAnimeToJson(RecentAnime data) => json.encode(data.toJson());

class RecentAnime {
  RecentAnime({
    required this.currentPage,
    required this.hasNextPage,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  String currentPage;
  bool hasNextPage;
  int totalPages;
  int totalResults;
  List<Result> results;

  factory RecentAnime.fromJson(Map<String, dynamic> json) => RecentAnime(
        currentPage: json["currentPage"].toString(),
        hasNextPage: json["hasNextPage"],
        totalPages: json["totalPages"],
        totalResults: json["totalResults"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "totalPages": totalPages,
        "totalResults": totalResults,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.malId,
    required this.title,
    required this.image,
    required this.rating,
    required this.color,
    required this.episodeId,
    required this.episodeTitle,
    required this.episodeNumber,
    required this.genres,
    required this.type,
  });

  String id;
  int malId;
  Title title;
  String image;
  int rating;
  String color;
  String episodeId;
  String episodeTitle;
  int episodeNumber;
  List<String> genres;
  String type;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        malId: json["malId"],
        title: Title.fromJson(json["title"]),
        image: json["image"],
        rating: json["rating"] == null ? null : json["rating"],
        color: json["color"] == null ? null : json["color"],
        episodeId: json["episodeId"],
        episodeTitle: json["episodeTitle"],
        episodeNumber: json["episodeNumber"],
        genres: List<String>.from(json["genres"].map((x) => x)),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "malId": malId,
        "title": title.toJson(),
        "image": image,
        "rating": rating == null ? null : rating,
        "color": color == null ? null : color,
        "episodeId": episodeId,
        "episodeTitle": episodeTitle,
        "episodeNumber": episodeNumber,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "type": type,
      };
}

class Title {
  Title({
    required this.romaji,
    required this.english,
    required this.native,
    required this.userPreferred,
  });

  String romaji;
  String english;
  String native;
  String userPreferred;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        romaji: json["romaji"],
        english: json["english"] == null ? null : json["english"],
        native: json["native"],
        userPreferred: json["userPreferred"],
      );

  Map<String, dynamic> toJson() => {
        "romaji": romaji,
        "english": english == null ? null : english,
        "native": native,
        "userPreferred": userPreferred,
      };
}
