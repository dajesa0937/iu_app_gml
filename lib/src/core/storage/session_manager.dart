import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _tokenKey = 'jwt_token';
  static const _roleKey = 'user_role';

  /// Guarda token y rol del usuario
  static Future<void> saveSession({
    required String token,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
  }

  /// Obtiene el token JWT
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Obtiene el rol del usuario
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Limpia toda la sesión (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
