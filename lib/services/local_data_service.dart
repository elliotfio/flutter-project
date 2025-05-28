import 'dart:convert';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class News {
  final String title;
  final String date;
  final String content;
  final String? imageUrl;

  News({
    required this.title,
    required this.date,
    required this.content,
    this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] as String,
      date: json['date'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class DailyFact {
  final String content;
  final String date;

  DailyFact({
    required this.content,
    required this.date,
  });

  factory DailyFact.fromJson(Map<String, dynamic> json) {
    return DailyFact(
      content: json['content'] as String,
      date: json['date'] as String,
    );
  }
}

class Episode {
  final int id;
  final int seasonNumber;
  final int episodeNumber;
  final String title;
  final String description;
  final List<String> characters;
  final String airDate;

  Episode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.characters,
    required this.airDate,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as int,
      seasonNumber: json['seasonNumber'] as int,
      episodeNumber: json['episodeNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      characters: List<String>.from(json['characters'] as List<dynamic>),
      airDate: json['airDate'] as String,
    );
  }
}

class Character {
  final int id;
  final String name;
  final String description;
  final List<int> episodeIds;
  final String occupation;
  final String catchphrase;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.episodeIds,
    required this.occupation,
    required this.catchphrase,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      episodeIds: List<int>.from(json['episodeIds'] as List<dynamic>),
      occupation: json['occupation'] as String,
      catchphrase: json['catchphrase'] as String,
    );
  }
}

class Dossier {
  final int id;
  final String title;
  final String content;
  final String author;
  final DateTime publishDate;
  final List<String> tags;

  Dossier({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.tags,
  });

  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      tags: List<String>.from(json['tags'] as List<dynamic>),
    );
  }
}

class LocalDataService {
  // Cette fonction chargera les actualités depuis un fichier JSON local
  Future<List<News>> getLatestNews() async {
    try {
      // TODO: Décommenter ce code quand le fichier JSON sera créé
      // final String jsonString = await rootBundle.loadString(AppConstants.newsJsonPath);
      // final List<dynamic> jsonList = json.decode(jsonString);
      // return jsonList.map((json) => News.fromJson(json)).toList();

      // Données de test en attendant le fichier JSON
      return [
        News(
          title: "Les Simpson renouvelés pour 4 ans !",
          date: "3 avril 2025",
          content: "La série est renouvelée pour 4 saisons, jusqu'au printemps 2029.",
        ),
        News(
          title: "Funzo ! Funzo ! Funzo !",
          date: "29 mars 2025",
          content: "JAKKS Pacific a dévoilé une nouvelle gamme de jouets Simpson.",
        ),
        News(
          title: "Bonne année 2025",
          date: "2 janvier 2025",
          content: "Bonne année 2025 de la part de SimpsonParc !",
        ),
      ];
    } catch (e) {
      throw Exception('Erreur lors du chargement des actualités: $e');
    }
  }

  // Cette fonction chargera l'anecdote du jour depuis un fichier JSON local
  Future<DailyFact> getDailyFact() async {
    try {
      // TODO: Décommenter ce code quand le fichier JSON sera créé
      // final String jsonString = await rootBundle.loadString(AppConstants.dailyFactsJsonPath);
      // final List<dynamic> jsonList = json.decode(jsonString);
      // final int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
      // final int factIndex = dayOfYear % jsonList.length;
      // return DailyFact.fromJson(jsonList[factIndex]);

      // Donnée de test en attendant le fichier JSON
      return DailyFact(
        content: "La loi russe contraint la télévision de ce pays à censurer certains dessins animés dont les Simpson. En raison de certaines scènes de violence, de sexe et d'incitation à la consommation de drogue et d'alcool dans les programmes pour la jeunesse.",
        date: DateTime.now().toString(),
      );
    } catch (e) {
      throw Exception('Erreur lors du chargement de l\'anecdote: $e');
    }
  }

  // Cette fonction chargera les épisodes depuis un fichier JSON local
  Future<List<Episode>> getEpisodesBySeason(int seasonNumber) async {
    try {
      // TODO: Décommenter ce code quand le fichier JSON sera créé
      // final String jsonString = await rootBundle.loadString(AppConstants.episodesJsonPath);
      // final List<dynamic> jsonList = json.decode(jsonString);
      // return jsonList
      //     .where((json) => json['seasonNumber'] == seasonNumber)
      //     .map((json) => Episode.fromJson(json))
      //     .toList();

      // Données de test en attendant le fichier JSON
      return List.generate(5, (index) => Episode(
        id: index + 1,
        seasonNumber: seasonNumber,
        episodeNumber: index + 1,
        title: 'Épisode ${index + 1}',
        description: 'Description de l\'épisode ${index + 1} de la saison $seasonNumber',
        characters: ['Homer', 'Marge', 'Bart', 'Lisa', 'Maggie'],
        airDate: '2025-01-${index + 1}',
      ));
    } catch (e) {
      throw Exception('Erreur lors du chargement des épisodes: $e');
    }
  }

  // Cette fonction chargera les personnages depuis un fichier JSON local
  Future<List<Character>> getCharacters() async {
    try {
      // TODO: Décommenter ce code quand le fichier JSON sera créé
      // final String jsonString = await rootBundle.loadString(AppConstants.charactersJsonPath);
      // final List<dynamic> jsonList = json.decode(jsonString);
      // return jsonList.map((json) => Character.fromJson(json)).toList();

      // Données de test en attendant le fichier JSON
      return [
        Character(
          id: 1,
          name: 'Homer Simpson',
          description: 'Le patriarche de la famille Simpson',
          episodeIds: List.generate(10, (index) => index + 1),
          occupation: 'Inspecteur de sécurité',
          catchphrase: 'D\'oh!',
        ),
        Character(
          id: 2,
          name: 'Marge Simpson',
          description: 'La matriarche de la famille Simpson',
          episodeIds: List.generate(10, (index) => index + 1),
          occupation: 'Femme au foyer',
          catchphrase: 'Mmmmh...',
        ),
        // Ajoutez d'autres personnages ici
      ];
    } catch (e) {
      throw Exception('Erreur lors du chargement des personnages: $e');
    }
  }

  // Cette fonction chargera les dossiers depuis un fichier JSON local
  Future<List<Dossier>> getDossiers() async {
    try {
      // TODO: Décommenter ce code quand le fichier JSON sera créé
      // final String jsonString = await rootBundle.loadString(AppConstants.dossiersJsonPath);
      // final List<dynamic> jsonList = json.decode(jsonString);
      // return jsonList.map((json) => Dossier.fromJson(json)).toList();

      // Données de test en attendant le fichier JSON
      return [
        Dossier(
          id: 1,
          title: 'L\'image de la France dans les Simpson',
          content: 'Analyse détaillée de la représentation de la France...',
          author: 'Admin',
          publishDate: DateTime.now(),
          tags: ['France', 'Culture', 'Analyse'],
        ),
        Dossier(
          id: 2,
          title: 'Les canulars téléphoniques au bar de Moe',
          content: 'Compilation et analyse des célèbres canulars...',
          author: 'Admin',
          publishDate: DateTime.now(),
          tags: ['Moe', 'Humour', 'Compilation'],
        ),
        // Ajoutez d'autres dossiers ici
      ];
    } catch (e) {
      throw Exception('Erreur lors du chargement des dossiers: $e');
    }
  }
} 