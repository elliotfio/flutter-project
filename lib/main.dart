import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/episodes_screen.dart';
import 'screens/characters_screen.dart';
import 'screens/dossiers_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/manage_admins_screen.dart';
import 'screens/admin/manage_dossiers_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const SimpsonParcApp());
}

final _authService = AuthService();

// Middleware pour vérifier l'authentification
Future<String?> _authGuard(BuildContext context, GoRouterState state) async {
  final isAuthenticated = await _authService.isAuthenticated();
  if (!isAuthenticated) {
    return '/login';
  }
  return null;
}

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Routes protégées pour l'administration
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => AdminDashboardScreen(),
      redirect: _authGuard,
    ),
    GoRoute(
      path: '/admin/admins',
      builder: (context, state) => const ManageAdminsScreen(),
      redirect: _authGuard,
    ),
    GoRoute(
      path: '/admin/dossiers',
      builder: (context, state) => const ManageDossiersScreen(),
      redirect: _authGuard,
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              NavigationDestination(
                icon: Icon(Icons.tv),
                label: 'Épisodes',
              ),
              NavigationDestination(
                icon: Icon(Icons.people),
                label: 'Personnages',
              ),
              NavigationDestination(
                icon: Icon(Icons.folder),
                label: 'Dossiers',
              ),
            ],
            selectedIndex: _calculateSelectedIndex(state),
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/episodes');
                  break;
                case 2:
                  context.go('/characters');
                  break;
                case 3:
                  context.go('/dossiers');
                  break;
              }
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/episodes',
          builder: (context, state) => const EpisodesScreen(),
        ),
        GoRoute(
          path: '/characters',
          builder: (context, state) => const CharactersScreen(),
        ),
        GoRoute(
          path: '/dossiers',
          builder: (context, state) => const DossiersScreen(),
        ),
      ],
    ),
  ],
);

int _calculateSelectedIndex(GoRouterState state) {
  final String location = state.uri.toString();
  if (location == '/home') return 0;
  if (location.startsWith('/episodes')) return 1;
  if (location.startsWith('/characters')) return 2;
  if (location.startsWith('/dossiers')) return 3;
  return 0;
}

class SimpsonParcApp extends StatelessWidget {
  const SimpsonParcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SimpsonParc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          primary: Colors.yellow,
          secondary: Colors.blue,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          elevation: 2,
          titleTextStyle: TextStyle(
            fontFamily: 'Simpsons',
            fontSize: 28,
            color: Colors.black,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
