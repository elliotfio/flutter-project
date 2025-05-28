import 'package:flutter/material.dart';

class AppConstants {
  // Chemins des fichiers JSON
  static const String newsJsonPath = 'assets/data/news.json';
  static const String dailyFactsJsonPath = 'assets/data/daily_facts.json';
  static const String episodesJsonPath = 'assets/data/episodes.json';
  static const String charactersJsonPath = 'assets/data/characters.json';
  static const String dossiersJsonPath = 'assets/data/dossiers.json';

  // Styles de texte
  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Simpsons',
    fontSize: 24,
    color: Colors.black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: 'Simpsons',
    fontSize: 20,
    color: Colors.black87,
  );

  // Textes de l'application
  static const String appTitle = 'SimpsonParc';
  static const String latestNewsTitle = 'Dernières actualités';
  static const String dailyFactTitle = 'L\'anecdote du jour';
  static const String episodesTitle = 'Épisodes des Simpsons';
  static const String charactersTitle = 'Personnages';
  static const String dossiersTitle = 'Dossiers Thématiques';

  // Messages d'erreur
  static const String loadingError = 'Erreur de chargement';
  static const String noFactAvailable = 'Aucune anecdote disponible';
  static const String noEpisodesAvailable = 'Aucun épisode disponible';
  static const String noCharactersAvailable = 'Aucun personnage disponible';
  static const String noDossiersAvailable = 'Aucun dossier disponible';

  // Valeurs par défaut
  static const int maxNewsItems = 5;
  static const double defaultPadding = 16.0;
  static const int totalSeasons = 34; // Nombre actuel de saisons
} 