import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Character {
  final String nom;
  final String image;
  final String description;

  Character({
    required this.nom,
    required this.image,
    required this.description,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      nom: json['nom'],
      image: json['image'],
      description: json['description'],
    );
  }
}

class ManageCharactersScreen extends StatelessWidget {
  const ManageCharactersScreen({super.key});

  Future<List<Character>> loadCharacters() async {
    final jsonString = await rootBundle.loadString('scrap/personnage.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Character.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gérer les personnages")),
      body: FutureBuilder<List<Character>>(
        future: loadCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Erreur lors du chargement"));
          }

          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: ListTile(
                  leading: Image.network(
                    character.image,
                    width: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 48),
                  ),
                  title: Text(character.nom),
                  subtitle: Text(
                    character.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
