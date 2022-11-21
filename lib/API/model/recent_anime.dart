class RecentAnime {
  RecentAnime({
    // id Detail
    required this.id,
    // id Episode
    required this.epsId,
    required this.currentEp,
    required this.epUrl,
    required this.title,
    required this.image,
    // required this.animeUrl,
  });

  final String id;
  final String epsId;
  final String title;
  final String epUrl;
  final String currentEp;
  final String image;
  // String animeUrl;

  factory RecentAnime.fromJson(Map<String, dynamic> json) => RecentAnime(
        id: json['id'],
        epsId: json['epsId'],
        title: json['title'],
        epUrl: json['epUrl'],
        currentEp: json['currentEp'],
        image: json['image'],
        // animeUrl: json['animeUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'epsId': epsId,
        'title': title,
        'epUrl': epUrl,
        'currentEp': currentEp,
        'image': image,
        // 'animeUrl': animeUrl,
      };
}
