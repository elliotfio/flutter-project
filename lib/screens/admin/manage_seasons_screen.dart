import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SeasonInfo {
  final int number;
  final int episodeCount;

  SeasonInfo({required this.number, required this.episodeCount});
}

class ManageSeasonsScreen extends StatefulWidget {
  const ManageSeasonsScreen({super.key});

  @override
  State<ManageSeasonsScreen> createState() => _ManageSeasonsScreenState();
}

class _ManageSeasonsScreenState extends State<ManageSeasonsScreen> {
  List<SeasonInfo> _seasons = [];

  @override
  void initState() {
    super.initState();
    _loadSeasons();
  }

  Future<void> _loadSeasons() async {
    List<SeasonInfo> tempSeasons = [];

    for (int i = 1; i <= 34; i++) {
      try {
        final jsonString = await rootBundle.loadString('scrap/saison$i.json');
        final List<dynamic> episodes = json.decode(jsonString);
        tempSeasons.add(SeasonInfo(number: i, episodeCount: episodes.length));
      } catch (_) {
        // Ignore missing files
      }
    }

    setState(() {
      _seasons = tempSeasons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des saisons')),
      body: _seasons.isEmpty
          ? const Center(child: Text('Aucune saison disponible'))
          : ListView.separated(
              itemCount: _seasons.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final s = _seasons[index];
                return ListTile(
                  title: Text('Saison ${s.number}'),
                  subtitle: Text('${s.episodeCount} épisode${s.episodeCount > 1 ? 's' : ''}'),
                  leading: CircleAvatar(child: Text('${s.number}')),
                );
              },
            ),
    );
  }
}
