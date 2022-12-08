// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

import 'package:http/http.dart' as http;
import 'package:my_anime_stream/API/model/detail.dart';
import 'package:my_anime_stream/API/model/episodeModa.dart';
import 'package:my_anime_stream/API/model/genreSelect.dart';
import 'package:my_anime_stream/API/model/popularAnime.dart';
import 'package:my_anime_stream/API/model/recent.dart';
import 'package:my_anime_stream/API/model/search.dart';
import 'package:my_anime_stream/API/model/top.dart';

class ApiService {
  String base_url = "https://api.consumet.org/meta/anilist/";
  String top_airing = "trending";
  String popular_anime = "popular";
  String recent_episodes = "recent-episodes";
  String detail_anime = "info";
  String episode_url = "watch";
  String genre_selected = "genre";

  Future popular() async {
    Uri urlApi = Uri.parse(base_url + popular_anime);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi, headers: requestHeaders);
    if (res.statusCode == 200) {
      return popularAnimeFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future top(page) async {
    Uri urlApi = Uri.parse(base_url + top_airing + "?page=$page&perPage=16");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi, headers: requestHeaders);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      if (data["results"] != null) {
        return topFromJson(res.body.toString());
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future recent(page) async {
    Uri urlApi =
        Uri.parse(base_url + recent_episodes + "?page=$page&perPage=16");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi, headers: requestHeaders);
    log("$urlApi");
    if (res.statusCode == 200) {
      return recentAnimeFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future detail(slug) async {
    Uri urlApi = Uri.parse(base_url + detail_anime + "/$slug");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi, headers: requestHeaders);

    if (res.statusCode == 200) {
      return detailFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future episode(slug) async {
    // log("$slug");
    Uri urlApi = Uri.parse(base_url + episode_url + "/$slug");
    log("$urlApi");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi, headers: requestHeaders);

    if (res.statusCode == 200) {
      return episodeFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future search(values, page) async {
    log("$values");
    Uri urlApi = Uri.parse("$base_url$values?page=$page&perPage=16");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final res = await http.get(urlApi, headers: requestHeaders);
    if (res.statusCode == 200) {
      return searchFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future genre(genre, page) async {
    final list = [];
    list.add(genre);
    Uri urlApi = Uri.parse(
      base_url + genre_selected + "?genres=" + "['$genre']",
    );
    String url = (base_url + genre_selected + "?genres=" + "['$genre']");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    log("$list, $urlApi");

    final res = await http.get(
      urlApi,
      headers: requestHeaders,
    );
    if (res.statusCode == 200) {
      return genreSelectFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future<String> fetchIframeEmbedded(url) async {
    print(url);
    Uri urlApi = Uri.parse(url);
    final response = await http.get(urlApi);
    dom.Document document = parse(response.body);
    var embededIframeUrl = document
        .getElementsByClassName('play-video')
        .first
        .getElementsByTagName('iframe')
        .first
        .attributes
        .values
        .first;
    return embededIframeUrl;
  }
}
