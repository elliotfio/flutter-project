import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../utils/constants.dart';

class DossiersScreen extends StatefulWidget {
  const DossiersScreen({super.key});

  @override
  State<DossiersScreen> createState() => _DossiersScreenState();
}

class _DossiersScreenState extends State<DossiersScreen> {
  final LocalDataService _dataService = LocalDataService();
  List<Dossier> _dossiers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDossiers();
  }

  Future<void> _loadDossiers() async {
    try {
      final dossiers = await _dataService.getDossiers();
      setState(() {
        _dossiers = dossiers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppConstants.loadingError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.dossiersTitle,
          style: const TextStyle(fontFamily: 'Simpsons'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dossiers.isEmpty
              ? Center(child: Text(AppConstants.noDossiersAvailable))
              : ListView.builder(
                  itemCount: _dossiers.length,
                  itemBuilder: (context, index) {
                    final dossier = _dossiers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: AppConstants.defaultPadding / 2,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          dossier.title,
                          style: AppConstants.titleStyle,
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.person, size: 16),
                            const SizedBox(width: 4),
                            Text(dossier.author),
                            const SizedBox(width: 16),
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${dossier.publishDate.day}/${dossier.publishDate.month}/${dossier.publishDate.year}',
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppConstants.defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dossier.content),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  children: dossier.tags.map((tag) {
                                    return Chip(
                                      label: Text(tag),
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
} 