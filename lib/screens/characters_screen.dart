import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../utils/constants.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalDataService dataService = LocalDataService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.charactersTitle,
          style: const TextStyle(fontFamily: 'Simpsons'),
        ),
      ),
      body: FutureBuilder<List<Character>>(
        future: dataService.getCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(AppConstants.loadingError));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppConstants.noCharactersAvailable));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final character = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.defaultPadding / 2,
                ),
                child: ExpansionTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    character.name,
                    style: AppConstants.titleStyle,
                  ),
                  subtitle: Text(character.occupation),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(character.description),
                          const SizedBox(height: 16),
                          Text(
                            'Phrase culte:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            character.catchphrase,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Apparaît dans ${character.episodeIds.length} épisodes',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
} 