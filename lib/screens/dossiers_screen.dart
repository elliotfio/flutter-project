import 'package:flutter/material.dart';
import '../services/local_data_service.dart';
import '../utils/constants.dart';
import 'edit_dossier_screen.dart';

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

  Future<void> _editDossier(BuildContext context, [Dossier? dossier]) async {
    final result = await Navigator.push<Dossier>(
      context,
      MaterialPageRoute(
        builder: (context) => EditDossierScreen(dossier: dossier),
      ),
    );

    if (result != null) {
      setState(() {
        if (dossier != null) {
          final index = _dossiers.indexWhere((d) => d.id == dossier.id);
          if (index != -1) {
            _dossiers[index] = result;
          }
        } else {
          _dossiers.add(result);
        }
      });
    }
  }

  Future<void> _deleteDossier(Dossier dossier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirmer la suppression',
          style: TextStyle(fontFamily: 'Simpsons'),
        ),
        content: Text('Voulez-vous vraiment supprimer le dossier "${dossier.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _dossiers.removeWhere((d) => d.id == dossier.id);
      });
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editDossier(context, dossier),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteDossier(dossier),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editDossier(context),
        child: const Icon(Icons.add),
      ),
    );
  }
} 