import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News {
  final int id;
  final String title;
  final String date;
  final String content;
  final String? imageUrl;
  final String source;

  News({
    required this.id,
    required this.title,
    required this.date,
    required this.content,
    this.imageUrl,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date,
    'content': content,
    'imageUrl': imageUrl,
    'source': source,
  };

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'],
    title: json['title'],
    date: json['date'],
    content: json['content'],
    imageUrl: json['imageUrl'],
    source: json['source'],
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'seasonNumber': seasonNumber,
    'episodeNumber': episodeNumber,
    'title': title,
    'description': description,
    'characters': characters,
    'airDate': airDate,
    'imageUrl': imageUrl,
  };

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    id: json['id'],
    seasonNumber: json['seasonNumber'],
    episodeNumber: json['episodeNumber'],
    title: json['title'],
    description: json['description'],
    characters: List<String>.from(json['characters'] ?? []),
    airDate: json['airDate'] ?? '',
    imageUrl: json['imageUrl'],
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'episodeIds': episodeIds,
    'occupation': occupation,
    'catchphrase': catchphrase,
    'imageUrl': imageUrl,
  };

  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    episodeIds: List<int>.from(json['episodeIds'] ?? []),
    occupation: json['occupation'] ?? '',
    catchphrase: json['catchphrase'] ?? '',
    imageUrl: json['imageUrl'],
  );
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'author': author,
    'publishDate': publishDate.toIso8601String(),
    'tags': tags,
  };

  factory Dossier.fromJson(Map<String, dynamic> json) => Dossier(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    author: json['author'],
    publishDate: DateTime.parse(json['publishDate']),
    tags: List<String>.from(json['tags'] ?? []),
  );
}

class Season {
  final int number;
  final int episodeCount;
  final String year;
  final String description;

  Season({
    required this.number,
    required this.episodeCount,
    required this.year,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'number': number,
    'episodeCount': episodeCount,
    'year': year,
    'description': description,
  };

  factory Season.fromJson(Map<String, dynamic> json) => Season(
    number: json['number'],
    episodeCount: json['episodeCount'],
    year: json['year'] ?? '',
    description: json['description'] ?? '',
  );
}

class LocalDataService {
  static const String _newsKey = 'simpson_news';
  static const String _episodesKey = 'simpson_episodes';
  static const String _charactersKey = 'simpson_characters';
  static const String _dossiersKey = 'simpson_dossiers';
  static const String _seasonsKey = 'simpson_seasons';

  // ============= NEWS CRUD =============
  Future<List<News>> getLatestNews() async {
    final prefs = await SharedPreferences.getInstance();
    final newsJson = prefs.getStringList(_newsKey) ?? [];
    if (newsJson.isEmpty) {
      await _initializeDefaultNews();
      return getLatestNews();
    }
    return newsJson.map((json) => News.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _initializeDefaultNews() async {
    final defaultNews = [
      News(id: 1, title: 'Les Simpson fêtent leurs 35 ans', date: '2024-12-17', content: 'La série culte des Simpson continue d\'évoluer après plus de trois décennies.', source: 'SimpsonParc', imageUrl: null),
      News(id: 2, title: 'Nouvelle saison en préparation', date: '2024-12-15', content: 'Matt Groening annonce de nouveaux épisodes pour 2025.', source: 'Animation Weekly', imageUrl: null),
    ];
    await _saveNewsList(defaultNews);
  }

  Future<void> addNews(News news) async {
    final newsList = await getLatestNews();
    final maxId = newsList.isEmpty ? 0 : newsList.map((n) => n.id).reduce((a, b) => a > b ? a : b);
    final newNews = News(
      id: maxId + 1,
      title: news.title,
      date: news.date,
      content: news.content,
      imageUrl: news.imageUrl,
      source: news.source,
    );
    newsList.insert(0, newNews);
    await _saveNewsList(newsList);
  }

  Future<void> updateNews(News news) async {
    final newsList = await getLatestNews();
    final index = newsList.indexWhere((n) => n.id == news.id);
    if (index != -1) {
      newsList[index] = news;
      await _saveNewsList(newsList);
    }
  }

  Future<void> deleteNews(int id) async {
    final newsList = await getLatestNews();
    newsList.removeWhere((n) => n.id == id);
    await _saveNewsList(newsList);
  }

  Future<void> _saveNewsList(List<News> newsList) async {
    final prefs = await SharedPreferences.getInstance();
    final newsJson = newsList.map((news) => jsonEncode(news.toJson())).toList();
    await prefs.setStringList(_newsKey, newsJson);
  }

  // ============= EPISODES CRUD =============
  Future<List<Episode>> getEpisodesBySeason(int seasonNumber) async {
    final allEpisodes = await getAllEpisodes();
    return allEpisodes.where((e) => e.seasonNumber == seasonNumber).toList();
  }

  Future<List<Episode>> getAllEpisodes() async {
    final prefs = await SharedPreferences.getInstance();
    final episodesJson = prefs.getStringList(_episodesKey) ?? [];
    if (episodesJson.isEmpty) {
      await _initializeDefaultEpisodes();
      return getAllEpisodes();
    }
    return episodesJson.map((json) => Episode.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _initializeDefaultEpisodes() async {
    try {
      final allEpisodes = <Episode>[];
      for (int season = 1; season <= 34; season++) {
        try {
          final String jsonString = await rootBundle.loadString('scrap/saison$season.json');
          final List<dynamic> jsonList = json.decode(jsonString);
          final episodes = jsonList.map((json) {
            final titleParts = json['titre'].toString().split(' - ');
            final episodeNumber = int.parse(titleParts[0].substring(4, 6));
            return Episode(
              id: (season * 100) + episodeNumber,
              seasonNumber: season,
              episodeNumber: episodeNumber,
              title: titleParts.length > 1 ? titleParts[1] : titleParts[0],
              description: json['description'] as String,
              imageUrl: json['image'] as String,
              characters: [],
              airDate: '',
            );
          }).toList();
          allEpisodes.addAll(episodes);
        } catch (e) {
          // Ignore missing seasons
        }
      }
      await _saveEpisodesList(allEpisodes);
    } catch (e) {
      // Fallback to empty list
    }
  }

  Future<void> addEpisode(Episode episode) async {
    final episodes = await getAllEpisodes();
    final maxId = episodes.isEmpty ? 0 : episodes.map((e) => e.id).reduce((a, b) => a > b ? a : b);
    final newEpisode = Episode(
      id: maxId + 1,
      seasonNumber: episode.seasonNumber,
      episodeNumber: episode.episodeNumber,
      title: episode.title,
      description: episode.description,
      characters: episode.characters,
      airDate: episode.airDate,
      imageUrl: episode.imageUrl,
    );
    episodes.add(newEpisode);
    await _saveEpisodesList(episodes);
  }

  Future<void> updateEpisode(Episode episode) async {
    final episodes = await getAllEpisodes();
    final index = episodes.indexWhere((e) => e.id == episode.id);
    if (index != -1) {
      episodes[index] = episode;
      await _saveEpisodesList(episodes);
    }
  }

  Future<void> deleteEpisode(int id) async {
    final episodes = await getAllEpisodes();
    episodes.removeWhere((e) => e.id == id);
    await _saveEpisodesList(episodes);
  }

  Future<void> _saveEpisodesList(List<Episode> episodes) async {
    final prefs = await SharedPreferences.getInstance();
    final episodesJson = episodes.map((episode) => jsonEncode(episode.toJson())).toList();
    await prefs.setStringList(_episodesKey, episodesJson);
  }

  // ============= CHARACTERS CRUD =============
  Future<List<Character>> getCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    final charactersJson = prefs.getStringList(_charactersKey) ?? [];
    if (charactersJson.isEmpty) {
      await _initializeDefaultCharacters();
      return getCharacters();
    }
    return charactersJson.map((json) => Character.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _initializeDefaultCharacters() async {
    try {
      final String jsonString = await rootBundle.loadString('scrap/personnage.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final characters = jsonList.map((json) {
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
      await _saveCharactersList(characters);
    } catch (e) {
      // Fallback to empty list
    }
  }

  Future<void> addCharacter(Character character) async {
    final characters = await getCharacters();
    final maxId = characters.isEmpty ? 0 : characters.map((c) => c.id).reduce((a, b) => a > b ? a : b);
    final newCharacter = Character(
      id: maxId + 1,
      name: character.name,
      description: character.description,
      episodeIds: character.episodeIds,
      occupation: character.occupation,
      catchphrase: character.catchphrase,
      imageUrl: character.imageUrl,
    );
    characters.add(newCharacter);
    await _saveCharactersList(characters);
  }

  Future<void> updateCharacter(Character character) async {
    final characters = await getCharacters();
    final index = characters.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      characters[index] = character;
      await _saveCharactersList(characters);
    }
  }

  Future<void> deleteCharacter(int id) async {
    final characters = await getCharacters();
    characters.removeWhere((c) => c.id == id);
    await _saveCharactersList(characters);
  }

  Future<void> _saveCharactersList(List<Character> characters) async {
    final prefs = await SharedPreferences.getInstance();
    final charactersJson = characters.map((character) => jsonEncode(character.toJson())).toList();
    await prefs.setStringList(_charactersKey, charactersJson);
  }

  // ============= DOSSIERS CRUD =============
  Future<List<Dossier>> getDossiers() async {
    final prefs = await SharedPreferences.getInstance();
    final dossiersJson = prefs.getStringList(_dossiersKey) ?? [];
    if (dossiersJson.isEmpty) {
      await _initializeDefaultDossiers();
      return getDossiers();
    }
    return dossiersJson.map((json) => Dossier.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _initializeDefaultDossiers() async {
    final defaultDossiers = [
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
    ];
    await _saveDossiersList(defaultDossiers);
  }

  Future<void> addDossier(Dossier dossier) async {
    final dossiers = await getDossiers();
    final maxId = dossiers.isEmpty ? 0 : dossiers.map((d) => d.id).reduce((a, b) => a > b ? a : b);
    final newDossier = Dossier(
      id: maxId + 1,
      title: dossier.title,
      content: dossier.content,
      author: dossier.author,
      publishDate: dossier.publishDate,
      tags: dossier.tags,
    );
    dossiers.insert(0, newDossier);
    await _saveDossiersList(dossiers);
  }

  Future<void> updateDossier(Dossier dossier) async {
    final dossiers = await getDossiers();
    final index = dossiers.indexWhere((d) => d.id == dossier.id);
    if (index != -1) {
      dossiers[index] = dossier;
      await _saveDossiersList(dossiers);
    }
  }

  Future<void> deleteDossier(int id) async {
    final dossiers = await getDossiers();
    dossiers.removeWhere((d) => d.id == id);
    await _saveDossiersList(dossiers);
  }

  Future<void> _saveDossiersList(List<Dossier> dossiers) async {
    final prefs = await SharedPreferences.getInstance();
    final dossiersJson = dossiers.map((dossier) => jsonEncode(dossier.toJson())).toList();
    await prefs.setStringList(_dossiersKey, dossiersJson);
  }

  // ============= SEASONS CRUD =============
  Future<List<Season>> getSeasons() async {
    final prefs = await SharedPreferences.getInstance();
    final seasonsJson = prefs.getStringList(_seasonsKey) ?? [];
    if (seasonsJson.isEmpty) {
      await _initializeDefaultSeasons();
      return getSeasons();
    }
    return seasonsJson.map((json) => Season.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _initializeDefaultSeasons() async {
    final allEpisodes = await getAllEpisodes();
    final seasons = <Season>[];
    for (int i = 1; i <= 34; i++) {
      final seasonEpisodes = allEpisodes.where((e) => e.seasonNumber == i).length;
      seasons.add(Season(
        number: i,
        episodeCount: seasonEpisodes,
        year: (1989 + i).toString(),
        description: 'Saison $i des Simpson',
      ));
    }
    await _saveSeasonsList(seasons);
  }

  Future<void> addSeason(Season season) async {
    final seasons = await getSeasons();
    seasons.add(season);
    seasons.sort((a, b) => a.number.compareTo(b.number));
    await _saveSeasonsList(seasons);
  }

  Future<void> updateSeason(Season season) async {
    final seasons = await getSeasons();
    final index = seasons.indexWhere((s) => s.number == season.number);
    if (index != -1) {
      seasons[index] = season;
      await _saveSeasonsList(seasons);
    }
  }

  Future<void> deleteSeason(int number) async {
    final seasons = await getSeasons();
    seasons.removeWhere((s) => s.number == number);
    await _saveSeasonsList(seasons);
    
    // Also delete all episodes from this season
    final episodes = await getAllEpisodes();
    episodes.removeWhere((e) => e.seasonNumber == number);
    await _saveEpisodesList(episodes);
  }

  Future<void> _saveSeasonsList(List<Season> seasons) async {
    final prefs = await SharedPreferences.getInstance();
    final seasonsJson = seasons.map((season) => jsonEncode(season.toJson())).toList();
    await prefs.setStringList(_seasonsKey, seasonsJson);
  }

  // ============= DAILY FACT =============
  Future<DailyFact> getDailyFact() async {
    return DailyFact(
      content: "La loi russe contraint la télévision de ce pays à censurer certains dessins animés dont les Simpson.",
      date: DateTime.now().toString(),
    );
  }
} 