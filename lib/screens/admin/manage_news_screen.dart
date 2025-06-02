import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class News {
  final String title;
  final String date;
  final String content;
  final String source;
  final String? imageUrl;

  News({
    required this.title,
    required this.date,
    required this.content,
    required this.source,
    this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['titre'],
      date: json['date'],
      content: json['resume'],
      source: json['source'],
      imageUrl: json['url'],
    );
  }
}

class ManageNewsScreen extends StatefulWidget {
  const ManageNewsScreen({super.key});

  @override
  State<ManageNewsScreen> createState() => _ManageNewsScreenState();
}

class _ManageNewsScreenState extends State<ManageNewsScreen> {
  List<News> _news = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final jsonString = await rootBundle.loadString('scrap/actu.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<dynamic> newsList = jsonMap['actualites']; // 👈 garde ta logique d'origine

    setState(() {
      _news = newsList.map((json) => News.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gérer les actualités')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Actualités publiées',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _news.isEmpty
                  ? const Center(child: Text('Aucune actualité disponible'))
                  : ListView.builder(
                      itemCount: _news.length,
                      itemBuilder: (context, index) {
                        final news = _news[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: news.imageUrl != null
                                ? Image.network(
                                    news.imageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 80),
                                  )
                                : const Icon(Icons.broken_image, size: 80),
                            title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(news.date),
                                const SizedBox(height: 4),
                                Text(news.content, maxLines: 3, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Text("Source : ${news.source}", style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
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
