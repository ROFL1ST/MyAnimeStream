// To parse this JSON data, do
//
//     final genreSelect = genreSelectFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GenreSelect genreSelectFromJson(String str) => GenreSelect.fromJson(json.decode(str));

String genreSelectToJson(GenreSelect data) => json.encode(data.toJson());

class GenreSelect {
    GenreSelect({
        required this.currentPage,
        required this.hasNextPage,
        required this.results,
    });

    int currentPage;
    bool hasNextPage;
    List<Result> results;

    factory GenreSelect.fromJson(Map<String, dynamic> json) => GenreSelect(
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
        required this.image,
        required this.trailer,
        required this.description,
        required this.cover,
        required this.rating,
        required this.releaseDate,
        required this.color,
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
    String cover;
    int rating;
    int releaseDate;
    String color;
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
        cover: json["cover"],
        rating: json["rating"],
        releaseDate: json["releaseDate"],
        color: json["color"],
        totalEpisodes: json["totalEpisodes"],
        duration: json["duration"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "malId": malId,
        "title": title.toJson(),
        "image": image,
        "trailer": trailer.toJson(),
        "description": description,
        "cover": cover,
        "rating": rating,
        "releaseDate": releaseDate,
        "color": color,
        "totalEpisodes": totalEpisodes,
        "duration": duration,
        "type": type
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

class Trailer {
    Trailer();

    factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
    );

    Map<String, dynamic> toJson() => {
    };
}

