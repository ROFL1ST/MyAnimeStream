class Favorite {
  Favorite({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  final String id;
  final String title;
  final String url;
  final String image;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'] as String,
        title: json['title'] as String,
        image: json['image'] as String,
        url: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'url': url,
      };
}
