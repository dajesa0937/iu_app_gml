import '../storage/session_manager.dart';

class RoleHelper {
  static Future<bool> isAdmin() async {
    final role = await SessionManager.getRole();
    return role == 'admin';
  }
}
