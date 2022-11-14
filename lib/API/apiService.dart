import 'dart:convert';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

import 'package:http/http.dart' as http;
import 'package:my_anime_stream/API/model/detail.dart';
import 'package:my_anime_stream/API/model/episodeModa.dart';
import 'package:my_anime_stream/API/model/recent.dart';
import 'package:my_anime_stream/API/model/top.dart';

class ApiService {
  String base_url = "https://api.consumet.org/anime/gogoanime/";
  String top_airing = "top-airing";
  String recent_episodes = "recent-episodes";
  String detail_anime = "info";
  String episode_url = "watch";

  Future top() async {
    Uri urlApi = Uri.parse(base_url + top_airing);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      return topFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future recent() async {
    Uri urlApi = Uri.parse(base_url + recent_episodes);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      return recentFromJson(res.body.toString());
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

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      return detailFromJson(res.body.toString());
    } else {
      return false;
    }
  }

  Future episode(slug) async {
    Uri urlApi = Uri.parse(base_url + episode_url + "/$slug");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      return episodeFromJson(res.body.toString());
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
