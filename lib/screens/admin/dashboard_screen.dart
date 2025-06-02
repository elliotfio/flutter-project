import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/local_data_service.dart';
import '../../utils/constants.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final LocalDataService _dataService = LocalDataService();
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;
  
  // Variables pour les statistiques
  int _totalEpisodes = 0;
  int _totalCharacters = 0;
  int _totalSeasons = AppConstants.totalSeasons;
  int _totalDossiers = 0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _cardAnimations = List.generate(6, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + index * 0.1,
          curve: Curves.easeOutBack,
        ),
      ));
    });
    
    _loadStatistics();
    _animationController.forward();
  }

  Future<void> _loadStatistics() async {
    try {
      // Charger les personnages
      final characters = await _dataService.getCharacters();
      
      // Charger les dossiers
      final dossiers = await _dataService.getDossiers();
      
      // Charger les épisodes de toutes les saisons pour compter le total
      int episodeCount = 0;
      for (int season = 1; season <= AppConstants.totalSeasons; season++) {
        try {
          final episodes = await _dataService.getEpisodesBySeason(season);
          episodeCount += episodes.length;
        } catch (e) {
          // Si une saison n'existe pas, on ignore l'erreur et continue
          continue;
        }
      }
      
      setState(() {
        _totalCharacters = characters.length;
        _totalDossiers = dossiers.length;
        _totalEpisodes = episodeCount;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStats = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD521),
              Color(0xFFFFE55C),
              Color(0xFFFFF9C4),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // AppBar moderne
              SliverAppBar(
                expandedHeight: 80.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 8),
                  title: const Text(
                    'Dashboard Admin',
                    style: TextStyle(
                      fontFamily: 'Simpsons',
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 6, bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.black87, size: 20),
                      onPressed: () async {
                        await _authService.logout();
                        if (context.mounted) {
                          context.go('/home');
                        }
                      },
                    ),
                  ),
                ],
              ),
              // Contenu
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Message de bienvenue
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD521).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: Color(0xFFFFD521),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Bienvenue, Administrateur !',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Gérez facilement l\'univers des Simpsons',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Statistiques rapides
                    _buildStatsSection(),
                    const SizedBox(height: 16),
                    // Titre des actions
                    const Text(
                      'Actions de gestion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Grille des cartes
                    _buildAdminGrid(),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu rapide',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Episodes',
                  _isLoadingStats ? '...' : '$_totalEpisodes',
                  Icons.tv,
                  const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildStatCard(
                  'Personnages',
                  _isLoadingStats ? '...' : '$_totalCharacters',
                  Icons.people,
                  const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Saisons',
                  '$_totalSeasons',
                  Icons.playlist_play,
                  const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildStatCard(
                  'Dossiers',
                  _isLoadingStats ? '...' : '$_totalDossiers',
                  Icons.folder,
                  const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 12),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminGrid() {
    final adminItems = [
      {
        'title': 'Gérer les administrateurs',
        'icon': Icons.admin_panel_settings,
        'color': const Color(0xFF9C27B0),
        'route': '/admin/admins',
        'description': 'Ajouter et gérer les comptes admin',
      },
      {
        'title': 'Gérer les épisodes',
        'icon': Icons.tv,
        'color': const Color(0xFF4CAF50),
        'route': '/admin/episodes',
        'description': 'Episodes de toutes les saisons',
      },
      {
        'title': 'Gérer les saisons',
        'icon': Icons.playlist_play,
        'color': const Color(0xFF2196F3),
        'route': '/admin/seasons',
        'description': 'Organisation par saisons',
      },
      {
        'title': 'Gérer les personnages',
        'icon': Icons.people,
        'color': const Color(0xFFFF9800),
        'route': '/admin/characters',
        'description': 'Famille Simpson et autres',
      },
      {
        'title': 'Gérer les dossiers',
        'icon': Icons.folder_open,
        'color': const Color(0xFFE91E63),
        'route': '/admin/dossiers',
        'description': 'Contenu éditorial thématique',
      },
      {
        'title': 'Gérer les actualités',
        'icon': Icons.newspaper,
        'color': const Color(0xFFF44336),
        'route': '/admin/news',
        'description': 'News et informations',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.2,
      ),
      itemCount: adminItems.length,
      itemBuilder: (context, index) {
        final item = adminItems[index];
        return AnimatedBuilder(
          animation: _cardAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _cardAnimations[index].value,
              child: _buildAdminCard(
                context,
                item['title'] as String,
                item['description'] as String,
                item['icon'] as IconData,
                item['color'] as Color,
                () => context.push(item['route'] as String),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Gérer',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward, size: 9, color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 