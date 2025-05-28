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
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(character.imageUrl),
                    onBackgroundImageError: (e, s) {
                      // En cas d'erreur de chargement de l'image
                    },
                    child: const Icon(Icons.person),
                  ),
                  title: Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    character.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(character.description),
                          if (character.occupation.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Occupation:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(character.occupation),
                          ],
                          if (character.catchphrase.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Phrase culte:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              character.catchphrase,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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