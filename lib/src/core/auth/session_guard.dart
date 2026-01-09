import 'package:flutter/material.dart';
import '../storage/session_manager.dart';

class SessionGuard {
  static Future<void> handleSessionExpired(BuildContext context) async {
    await SessionManager.clear();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (_) => false,
    );
  }
}
