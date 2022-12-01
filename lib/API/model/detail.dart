// To parse this JSON data, do
//
//     final detail = detailFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Detail detailFromJson(String str) => Detail.fromJson(json.decode(str));

String detailToJson(Detail data) => json.encode(data.toJson());

class Detail {
  Detail({
    required this.id,
    required this.title,
    required this.malId,
    required this.synonyms,
    required this.isLicensed,
    required this.isAdult,
    required this.countryOfOrigin,
    required this.image,
    required this.popularity,
    required this.color,
    required this.cover,
    required this.description,
    required this.status,
    required this.releaseDate,
    required this.startDate,
    required this.endDate,
    required this.totalEpisodes,
    required this.rating,
    required this.duration,
    required this.genres,
    required this.season,
    required this.studios,
    required this.subOrDub,
    required this.hasSub,
    required this.hasDub,
    required this.type,
    required this.recommendations,
    required this.characters,
    required this.relations,
    required this.episodes,
  });

  String id;
  Title title;
  int malId;
  List<String> synonyms;
  bool isLicensed;
  bool isAdult;
  String countryOfOrigin;
  String image;
  int popularity;
  String color;
  String cover;
  String description;
  String status;
  int releaseDate;
  Date startDate;
  Date endDate;

  int totalEpisodes;
  int rating;
  int duration;
  List<String> genres;
  String season;
  List<String> studios;
  String subOrDub;
  bool hasSub;
  bool hasDub;
  String type;
  List<Ation> recommendations;
  List<Character> characters;
  List<Ation> relations;
  List<Episode> episodes;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        title: Title.fromJson(json["title"]),
        malId: json["malId"],
        synonyms: List<String>.from(json["synonyms"].map((x) => x)),
        isLicensed: json["isLicensed"],
        isAdult: json["isAdult"],
        countryOfOrigin: json["countryOfOrigin"],
        image: json["image"],
        popularity: json["popularity"],
        color: json["color"],
        cover: json["cover"],
        description: json["description"],
        status: json["status"],
        releaseDate: json["releaseDate"],
        startDate: Date.fromJson(json["startDate"]),
        endDate: Date.fromJson(json["endDate"]),
        totalEpisodes: json["totalEpisodes"],
        rating: json["rating"],
        duration: json["duration"],
        genres: List<String>.from(json["genres"].map((x) => x)),
        season: json["season"],
        studios: List<String>.from(json["studios"].map((x) => x)),
        subOrDub: json["subOrDub"],
        hasSub: json["hasSub"],
        hasDub: json["hasDub"],
        type: json["type"],
        recommendations: List<Ation>.from(
            json["recommendations"].map((x) => Ation.fromJson(x))),
        characters: List<Character>.from(
            json["characters"].map((x) => Character.fromJson(x))),
        relations:
            List<Ation>.from(json["relations"].map((x) => Ation.fromJson(x))),
        episodes: List<Episode>.from(
            json["episodes"].map((x) => Episode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title.toJson(),
        "malId": malId,
        "synonyms": List<dynamic>.from(synonyms.map((x) => x)),
        "isLicensed": isLicensed,
        "isAdult": isAdult,
        "countryOfOrigin": countryOfOrigin,
        "image": image,
        "popularity": popularity,
        "color": color,
        "cover": cover,
        "description": description,
        "status": status,
        "releaseDate": releaseDate,
        "startDate": startDate.toJson(),
        "endDate": endDate.toJson(),
        "totalEpisodes": totalEpisodes,
        "rating": rating,
        "duration": duration,
        "genres": List<dynamic>.from(genres.map((x) => x)),
        "season": season,
        "studios": List<dynamic>.from(studios.map((x) => x)),
        "subOrDub": subOrDub,
        "hasSub": hasSub,
        "hasDub": hasDub,
        "type": type,
        "recommendations":
            List<dynamic>.from(recommendations.map((x) => x.toJson())),
        "characters": List<dynamic>.from(characters.map((x) => x.toJson())),
        "relations": List<dynamic>.from(relations.map((x) => x.toJson())),
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
      };
}

class Character {
  Character({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
    required this.voiceActors,
  });

  int id;
  String role;
  Name name;
  String image;
  List<VoiceActor> voiceActors;

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json["id"],
        role: json["role"],
        name: Name.fromJson(json["name"]),
        image: json["image"],
        voiceActors: List<VoiceActor>.from(
            json["voiceActors"].map((x) => VoiceActor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name.toJson(),
        "image": image,
        "voiceActors": List<dynamic>.from(voiceActors.map((x) => x.toJson())),
      };
}

class Name {
  Name({
    required this.first,
    required this.last,
    required this.full,
    required this.native,
    required this.userPreferred,
  });

  String first;
  String last;
  String full;
  String native;
  String userPreferred;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        first: json["first"],
        last: json["last"] == null ? null : json["last"],
        full: json["full"],
        native: json["native"] == null ? null : json["native"],
        userPreferred: json["userPreferred"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last == null ? null : last,
        "full": full,
        "native": native == null ? null : native,
        "userPreferred": userPreferred,
      };
}

class VoiceActor {
  VoiceActor({
    required this.id,
    required this.language,
    required this.name,
    required this.image,
  });

  int id;
  String language;
  Name name;
  String image;

  factory VoiceActor.fromJson(Map<String, dynamic> json) => VoiceActor(
        id: json["id"],
        language: json["language"],
        name: Name.fromJson(json["name"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language": language,
        "name": name.toJson(),
        "image": image,
      };
}

class Date {
  Date({
    required this.year,
    required this.month,
    required this.day,
  });

  int year;
  int month;
  int day;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        year: json["year"] == null ? null : json["year"],
        month: json["month"] == null ? null : json["month"],
        day: json["day"] == null ? null : json["day"],
      );

  Map<String, dynamic> toJson() => {
        "year": year == null ? null : year,
        "month": month == null ? null : month,
        "day": day == null ? null : day,
      };
}

class Episode {
  Episode({
    required this.id,
    required this.title,
    required this.description,
    required this.number,
    required this.image,
  });

  String id;
  String title;
  String description;
  int number;
  String image;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        number: json["number"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "number": number,
        "image": image,
      };
}

class Ation {
  Ation({
    required this.id,
    required this.malId,
    required this.title,
    required this.status,
    required this.episodes,
    required this.image,
    required this.cover,
    required this.rating,
    required this.type,
    required this.relationType,
    required this.color,
  });

  int id;
  int malId;
  Title title;
  String status;
  int episodes;
  String image;
  String cover;
  int rating;
  String type;
  String relationType;
  String color;

  factory Ation.fromJson(Map<String, dynamic> json) => Ation(
        id: json["id"],
        malId: json["malId"] == null ? null : json["malId"],
        title: Title.fromJson(json["title"]),
        status: json["status"],
        episodes: json["episodes"] == null ? null : json["episodes"],
        image: json["image"],
        cover: json["cover"],
        rating: json["rating"],
        type: json["type"],
        relationType:
            json["relationType"] == null ? null : json["relationType"],
        color: json["color"] == null ? null : json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "malId": malId == null ? null : malId,
        "title": title.toJson(),
        "status": status,
        "episodes": episodes == null ? null : episodes,
        "image": image,
        "cover": cover,
        "rating": rating,
        "type": type,
        "relationType": relationType == null ? null : relationType,
        "color": color == null ? null : color,
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
        userPreferred:
            json["userPreferred"] == null ? null : json["userPreferred"],
      );

  Map<String, dynamic> toJson() => {
        "romaji": romaji,
        "english": english == null ? null : english,
        "native": native,
        "userPreferred": userPreferred == null ? null : userPreferred,
      };
}
