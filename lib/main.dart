import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/episodes_screen.dart';
import 'screens/characters_screen.dart';
import 'screens/dossiers_screen.dart';

void main() {
  runApp(const SimpsonParcApp());
}

final _router = GoRouter(
  routes: [
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
                  context.go('/');
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
          path: '/',
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
  if (location == '/') return 0;
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
