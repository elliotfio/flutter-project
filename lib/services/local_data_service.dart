import 'dart:convert';
import 'package:flutter/services.dart';

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
}

class DailyFact {
  final String content;
  final String date;

  DailyFact({
    required this.content,
    required this.date,
  });
}

class Episode {
  final int id;
  final int seasonNumber;
  final int episodeNumber;
  final String title;
  final String description;
  final List<String> characters;
  final String airDate;
  final String imageUrl;

  Episode({
    required this.id,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.characters,
    required this.airDate,
    required this.imageUrl,
  });
}

class Character {
  final int id;
  final String name;
  final String description;
  final List<int> episodeIds;
  final String occupation;
  final String catchphrase;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.episodeIds,
    required this.occupation,
    required this.catchphrase,
    required this.imageUrl,
  });
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
}

class LocalDataService {
  Future<List<News>> getLatestNews() async {
    try {
      throw UnimplementedError('Le scraping des actualités n\'est pas encore implémenté');
    } catch (e) {
      throw Exception('Erreur lors du chargement des actualités: $e');
    }
  }

  Future<DailyFact> getDailyFact() async {
    try {
      return DailyFact(
        content: "La loi russe contraint la télévision de ce pays à censurer certains dessins animés dont les Simpson. En raison de certaines scènes de violence, de sexe et d'incitation à la consommation de drogue et d'alcool dans les programmes pour la jeunesse.",
        date: DateTime.now().toString(),
      );
    } catch (e) {
      throw Exception('Erreur lors du chargement de l\'anecdote: $e');
    }
  }

  Future<List<Episode>> getEpisodesBySeason(int seasonNumber) async {
    try {
      final String jsonString = await rootBundle.loadString('scrap/saison$seasonNumber.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) {
        final titleParts = json['titre'].toString().split(' - ');
        final episodeNumber = int.parse(titleParts[0].substring(4, 6));
        
        return Episode(
          id: episodeNumber,
          seasonNumber: seasonNumber,
          episodeNumber: episodeNumber,
          title: titleParts[1],
          description: json['description'] as String,
          imageUrl: json['image'] as String,
          characters: [], 
          airDate: '', 
        );
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des épisodes: $e');
    }
  }

  Future<List<Character>> getCharacters() async {
    try {
      final String jsonString = await rootBundle.loadString('scrap/personnage.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) {
        return Character(
          id: jsonList.indexOf(json) + 1,
          name: json['nom'] as String,
          description: json['description'] as String,
          imageUrl: json['image'] as String,
          episodeIds: [], 
          occupation: '', 
          catchphrase: '', 
        );
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des personnages: $e');
    }
  }

  Future<List<Dossier>> getDossiers() async {
    try {
      return [
        Dossier(
          id: 1,
          title: 'L\'image de la France dans les Simpsons',
          content: 'Les Simpson ont souvent représenté la France et les Français dans leurs épisodes, généralement de manière stéréotypée mais affectueuse. De la gastronomie aux attitudes culturelles, en passant par les monuments emblématiques comme la Tour Eiffel, la série offre un regard américain amusant sur la culture française. Les épisodes notables incluent celui où la famille visite Paris et celui où Lisa devient étudiante d\'échange en France. Ces représentations, bien que caricaturales, ont contribué à la popularité de la série en France.',
          author: 'Admin',
          publishDate: DateTime.now(),
          tags: ['France', 'Culture', 'Analyse', 'International'],
        ),
        Dossier(
          id: 2,
          title: 'Les canulars telephoniques au bar de Moe',
          content: 'Une des blagues récurrentes les plus mémorables des Simpson sont les appels téléphoniques que Bart passe au bar de Moe. Ces canulars reposent sur un principe simple : Bart demande à parler à une personne dont le nom est un jeu de mots qui, une fois prononcé par Moe devant ses clients, devient une blague ou une situation embarrassante. Ces moments sont devenus cultes et illustrent parfaitement l\'humour de la série, mêlant espièglerie enfantine et références culturelles.',
          author: 'Admin',
          publishDate: DateTime.now(),
          tags: ['Moe', 'Humour', 'Compilation', 'Bart', 'Gags récurrents'],
        ),
        Dossier(
          id: 3,
          title: 'L\'evolution des Simpson a travers les saisons',
          content: 'Depuis leur première apparition en 1987 dans le Tracey Ullman Show jusqu\'à aujourd\'hui, les Simpson ont considérablement évolué, tant sur le plan graphique que narratif. Les premiers épisodes étaient plus bruts dans leur animation et plus centrés sur la dynamique familiale. Au fil des saisons, la série s\'est ouverte à des sujets plus variés, des commentaires sociaux plus pointus et des références culturelles plus sophistiquées. Cette évolution reflète aussi les changements de la société américaine sur plus de trois décennies.',
          author: 'Admin',
          publishDate: DateTime.now(),
          tags: ['Histoire', 'Animation', 'Évolution', 'Analyse'],
        ),
      ];
    } catch (e) {
      throw Exception('Erreur lors du chargement des dossiers: $e');
    }
  }
} 