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
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
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
    required this.malId,
    required this.title,
    required this.image,
    required this.trailer,
    required this.description,
    required this.status,
    required this.cover,
    required this.rating,
    required this.releaseDate,
    required this.genres,
    required this.totalEpisodes,
    required this.duration,
    required this.type,
  });

  String id;
  int malId;
  Title title;
  String image;
  Trailer trailer;
  String description;
  String status;
  String cover;
  int rating;
  int releaseDate;
  List<String> genres;
  int totalEpisodes;
  int duration;
  String type;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
      id: json["id"],
      malId: json["malId"],
      title: Title.fromJson(json["title"]),
      image: json["image"],
      trailer: Trailer.fromJson(json["trailer"]),
      description: json["description"],
      status: json["status"],
      cover: json["cover"],
      rating: json["rating"],
      releaseDate: json["releaseDate"],
      genres: List<String>.from(json["genres"].map((x) => x)),
      totalEpisodes: json["totalEpisodes"],
      duration: json["duration"],
      type: json["type"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "malId": malId,
        "title": title.toJson(),
        "image": image,
        "trailer": trailer.toJson(),
        "description": description,
        "status": status,
        "cover": cover,
        "rating": rating,
        "releaseDate": releaseDate,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "totalEpisodes": totalEpisodes,
        "duration": duration,
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
        english: json["english"],
        native: json["native"],
        userPreferred: json["userPreferred"],
      );

  Map<String, dynamic> toJson() => {
        "romaji": romaji,
        "english": english,
        "native": native,
        "userPreferred": userPreferred,
      };
}

class Trailer {
  Trailer({
    required this.id,
    required this.site,
    required this.thumbnail,
  });

  String id;
  String site;
  String thumbnail;

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        id: json["id"] == null ? null : json["id"],
        site: json["site"] == null ? null : json["site"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "site": site == null ? null : site,
        "thumbnail": thumbnail == null ? null : thumbnail,
      };
}
