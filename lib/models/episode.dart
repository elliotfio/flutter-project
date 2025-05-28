class Episode {
  final int id;
  final int seasonNumber;
  final int episodeNumber;
  final String title;
  final String description;
  final List<String> characters;
  final String airDate;
  final String? imageUrl;

  Episode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.characters,
    required this.airDate,
    this.imageUrl,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      seasonNumber: json['seasonNumber'] as int,
      episodeNumber: json['episodeNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      characters: List<String>.from(json['characters'] as List),
      airDate: json['airDate'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
      'title': title,
      'description': description,
      'characters': characters,
      'airDate': airDate,
      'imageUrl': imageUrl,
    };
  }
} 