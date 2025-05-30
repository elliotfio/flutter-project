import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isAdminKey = 'is_admin_logged_in';
  
  // Marquer comme connecté
  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdminKey, true);
  }

  // Déconnexion
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdminKey, false);
  }

  // Vérifier si l'admin est connecté
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminKey) ?? false;
  }
} 