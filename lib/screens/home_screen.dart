import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['titre'],
      date: json['date'],
      content: json['resume'],
      imageUrl: json['url'],
    );
  }
}

class DailyFact {
  final String content;
  final String date;

  DailyFact({required this.content, required this.date});
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List<News>> _loadNews() async {
    final jsonString = await rootBundle.loadString('scrap/actu.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> actuList = jsonMap['actualites'];
    return actuList.map((item) => News.fromJson(item)).toList();
  }

  Future<DailyFact> _loadDailyFact() async {
    return DailyFact(
      content: "Saviez-vous que Homer a une adresse email : chunkylover53@aol.com ?",
      date: "2025-05-30",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpsonParc'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Tu peux mettre une logique de refresh ici si besoin
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLatestNews(),
                const SizedBox(height: 24),
                _buildDailyFact(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dernières actualités',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<News>>(
          future: _loadNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erreur de chargement'));
            }
            final news = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: news.length,
              itemBuilder: (context, index) {
                final newsItem = news[index];
                return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    if (newsItem.imageUrl != null &&
                        await canLaunchUrl(Uri.parse(newsItem.imageUrl!))) {
                      launchUrl(Uri.parse(newsItem.imageUrl!));
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (newsItem.imageUrl != null)
                            const SizedBox(height: 16),
                          Text(
                            newsItem.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            newsItem.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            newsItem.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDailyFact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'L\'anecdote du jour',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<DailyFact>(
          future: _loadDailyFact(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erreur de chargement'));
            }
            final fact = snapshot.data;
            if (fact == null) {
              return const Center(child: Text('Aucune anecdote disponible'));
            }
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fact.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fact.date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
