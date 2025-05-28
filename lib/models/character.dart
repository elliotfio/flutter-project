class Character {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<int> episodeIds;
  final String? firstAppearance;
  final String? occupation;
  final String? catchphrase;

  Character({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.episodeIds,
    this.firstAppearance,
    this.occupation,
    this.catchphrase,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      episodeIds: List<int>.from(json['episodeIds'] as List),
      firstAppearance: json['firstAppearance'] as String?,
      occupation: json['occupation'] as String?,
      catchphrase: json['catchphrase'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'episodeIds': episodeIds,
      'firstAppearance': firstAppearance,
      'occupation': occupation,
      'catchphrase': catchphrase,
    };
  }
} 