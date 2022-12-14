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
        required this.malId,
        required this.title,
        required this.status,
        required this.image,
        required this.cover,
        required this.popularity,
        required this.description,
        required this.rating,
        required this.genres,
        required this.color,
        required this.totalEpisodes,
        required this.type,
        required this.releaseDate,
    });

    String id;
    int malId;
    Title title;
    String status;
    String image;
    String cover;
    int popularity;
    String description;
    int rating;
    List<String> genres;
    String color;
    int totalEpisodes;
    String type;
    dynamic releaseDate;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        malId: json["malId"] == null ? null : json["malId"],
        title: Title.fromJson(json["title"]),
        status: json["status"],
        image: json["image"],
        cover: json["cover"] == null ? null : json["cover"],
        popularity: json["popularity"],
        description: json["description"] == null ? null : json["description"],
        rating: json["rating"] == null ? null : json["rating"],
        genres: List<String>.from(json["genres"].map((x) => x)),
        color: json["color"],
        totalEpisodes: json["totalEpisodes"] == null ? null : json["totalEpisodes"],
        type: json["type"],
        releaseDate: json["releaseDate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "malId": malId == null ? null : malId,
        "title": title.toJson(),
        "status": status,
        "image": image,
        "cover": cover == null ? null : cover,
        "popularity": popularity,
        "description": description == null ? null : description,
        "rating": rating == null ? null : rating,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "color": color,
        "totalEpisodes": totalEpisodes == null ? null : totalEpisodes,
        "type": type,
        "releaseDate": releaseDate,
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
    dynamic english;
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
