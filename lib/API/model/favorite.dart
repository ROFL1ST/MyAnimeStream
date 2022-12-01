class Favorite {
  Favorite({
    required this.id,
    required this.title,
    required this.type,
    required this.image,
    required this.genre,
  });

  final String id;
  final String title;
  final String type;

  final String image;
  final String genre;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        image: json['image'] as String,
        genre: json['genre'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'image': image,
        'genre': genre,
      };
}
