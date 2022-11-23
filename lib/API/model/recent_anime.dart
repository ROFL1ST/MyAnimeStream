class RecentAnime {
  RecentAnime({
    // id Detail
    required this.id,
    // id Episode
    
    required this.episodeId,
    required this.currentEp,
    required this.epUrl,
    required this.title,
    required this.image,
    required this.createAt,
    // required this.animeUrl,
  });

  final String id;
 
  final String episodeId;

  final String title;
  final String epUrl;
  final String currentEp;
  final String image;
  final String createAt;

  factory RecentAnime.fromJson(Map<String, dynamic> json) => RecentAnime(
        id: json['id'],
     
        episodeId: json['episodeId'],
        title: json['title'],
        epUrl: json['epUrl'],
        currentEp: json['currentEp'],
        image: json['image'],
        createAt: json['createAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
       
        'episodeId': episodeId,
        'title': title,
        'epUrl': epUrl,
        'currentEp': currentEp,
        'image': image,
        'createAt': createAt,
      };
}
