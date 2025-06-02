import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Episode {
  final String titre;
  final String image;
  final String description;

  Episode({
    required this.titre,
    required this.image,
    required this.description,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      titre: json['titre'],
      image: json['image'],
      description: json['description'],
    );
  }
}

class ManageEpisodesScreen extends StatefulWidget {
  const ManageEpisodesScreen({super.key});

  @override
  State<ManageEpisodesScreen> createState() => _ManageEpisodesScreenState();
}

class _ManageEpisodesScreenState extends State<ManageEpisodesScreen> {
  int selectedSaison = 1;
  late Future<List<Episode>> futureEpisodes;

  @override
  void initState() {
    super.initState();
    futureEpisodes = loadEpisodes(selectedSaison);
  }

  Future<List<Episode>> loadEpisodes(int saison) async {
    try {
      final jsonString =
          await rootBundle.loadString('scrap/saison$saison.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => Episode.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  void onSaisonChanged(int newSaison) {
    setState(() {
      selectedSaison = newSaison;
      futureEpisodes = loadEpisodes(newSaison);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les épisodes')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Sélectionner une saison',
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedSaison,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (value) {
                  if (value != null) onSaisonChanged(value);
                },
                items: List.generate(34, (index) {
                  final saison = index + 1;
                  return DropdownMenuItem(
                    value: saison,
                    child: Text('Saison $saison'),
                  );
                }),
              ),
            ),
          ),
        ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Episode>>(
              future: futureEpisodes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text("Erreur lors du chargement"));
                }

                final episodes = snapshot.data!;
                if (episodes.isEmpty) {
                  return const Center(child: Text("Aucun épisode disponible"));
                }

                return ListView.builder(
                  itemCount: episodes.length,
                  itemBuilder: (context, index) {
                    final ep = episodes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: ListTile(
                        leading: Image.network(
                          ep.image,
                          width: 80,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 48),
                        ),
                        title: Text(ep.titre),
                        subtitle: Text(
                          ep.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
