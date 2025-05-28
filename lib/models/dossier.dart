class Dossier {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime publishDate;
  final List<String> tags;
  final List<int>? relatedEpisodeIds;
  final List<String>? relatedCharacters;
  final String? imageUrl;

  Dossier({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.tags,
    this.relatedEpisodeIds,
    this.relatedCharacters,
    this.imageUrl,
  });

  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      tags: List<String>.from(json['tags'] as List),
      relatedEpisodeIds: json['relatedEpisodeIds'] != null
          ? List<int>.from(json['relatedEpisodeIds'] as List)
          : null,
      relatedCharacters: json['relatedCharacters'] != null
          ? List<String>.from(json['relatedCharacters'] as List)
          : null,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'publishDate': publishDate.toIso8601String(),
      'tags': tags,
      'relatedEpisodeIds': relatedEpisodeIds,
      'relatedCharacters': relatedCharacters,
      'imageUrl': imageUrl,
    };
  }
} 