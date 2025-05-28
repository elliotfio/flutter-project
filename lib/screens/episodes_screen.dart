import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../utils/constants.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({super.key});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final LocalDataService _dataService = LocalDataService();
  int _selectedSeason = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.episodesTitle,
          style: const TextStyle(fontFamily: 'Simpsons'),
        ),
      ),
      body: Column(
        children: [
          // Sélecteur de saison
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: DropdownButton<int>(
              value: _selectedSeason,
              items: List.generate(
                AppConstants.totalSeasons,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('Saison ${index + 1}'),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSeason = value;
                  });
                }
              },
              isExpanded: true,
            ),
          ),
          // Liste des épisodes
          Expanded(
            child: FutureBuilder<List<Episode>>(
              future: _dataService.getEpisodesBySeason(_selectedSeason),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(AppConstants.loadingError));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(AppConstants.noEpisodesAvailable));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final episode = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: AppConstants.defaultPadding / 2,
                      ),
                      child: ListTile(
                        title: Text(
                          '${episode.episodeNumber}. ${episode.title}',
                          style: AppConstants.subtitleStyle,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(episode.description),
                            const SizedBox(height: 8),
                            Text(
                              'Personnages: ${episode.characters.join(", ")}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: Text(episode.airDate),
                        isThreeLine: true,
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