// ignore: file_names
class ContinueWatch {
  ContinueWatch({
    // id Detail
    required this.id,
    // id Episode
    required this.episodeId,
    required this.currentEp,
    required this.title,
    required this.type,
    required this.image,
    required this.imageEps,
    required this.createAt,
    // required this.animeUrl,
  });

  final String id;
  final String episodeId;

  final String title;
  final String type;

  final String currentEp;
  final String image;
  final String imageEps;

  final String createAt;

  factory ContinueWatch.fromJson(Map<String, dynamic> json) => ContinueWatch(
        id: json['id'],
        episodeId: json['episodeId'],
        title: json['title'],
        type: json['type'],
        currentEp: json['currentEp'],
        image: json['image'],
        imageEps: json['imageEps'],
        createAt: json['createAt'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'episodeId': episodeId,
        'title': title,
        'type': type,
        'currentEp': currentEp,
        'image': image,
        'imageEps': imageEps,
        'createAt': createAt,
      };
}
