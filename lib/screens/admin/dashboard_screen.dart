import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.logout();
              if (context.mounted) {
                context.go('/home');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue dans l\'interface d\'administration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildAdminCard(
                    context,
                    'Gérer les administrateurs',
                    Icons.admin_panel_settings,
                    Colors.purple,
                    () => context.push('/admin/admins'),
                  ),
                  _buildAdminCard(
                    context,
                    'Gérer les épisodes',
                    Icons.tv,
                    Colors.blue,
                    () => context.push('/admin/episodes'),
                  ),
                  _buildAdminCard(
                    context,
                    'Gérer les saisons',
                    Icons.playlist_play,
                    Colors.green,
                    () => context.push('/admin/seasons'),
                  ),
                  _buildAdminCard(
                    context,
                    'Gerer les personnages',
                    Icons.person,
                    Colors.amber,
                    () => context.push('/admin/characters'),
                  ),
                  _buildAdminCard(
                    context,
                    'Gérer les dossiers',
                    Icons.folder,
                    Colors.orange,
                    () => context.push('/admin/dossiers'),
                  ),
                  _buildAdminCard(
                    context,
                    'Gérer les actualités',
                    Icons.newspaper,
                    Colors.red,
                    () => context.push('/admin/news'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 