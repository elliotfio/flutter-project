import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Episode {
  final String titre;
  final String image;
  final String description;

  Episode({required this.titre, required this.image, required this.description});

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
  int selectedSeason = 1;
  late Future<List<Episode>> episodesFuture;

  @override
  void initState() {
    super.initState();
    episodesFuture = loadEpisodes(selectedSeason);
  }

  Future<List<Episode>> loadEpisodes(int season) async {
    final jsonString = await rootBundle.loadString('scrap/saison$season.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Episode.fromJson(e)).toList();
  }

  void onSeasonChanged(int newSeason) {
    setState(() {
      selectedSeason = newSeason;
      episodesFuture = loadEpisodes(newSeason);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Episodes des Simpsons')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<int>(
              value: selectedSeason,
              onChanged: (val) => onSeasonChanged(val!),
              items: List.generate(34, (i) {
                final season = i + 1;
                return DropdownMenuItem(
                  value: season,
                  child: Text('Saison $season'),
                );
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Episode>>(
                future: episodesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun épisode.'));
                  }

                  final episodes = snapshot.data!;
                  return ListView.builder(
                    itemCount: episodes.length,
                    itemBuilder: (context, index) {
                      final ep = episodes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              ep.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
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
      ),
    );
  }
}
