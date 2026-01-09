import 'package:flutter/material.dart';
import '../storage/session_manager.dart';

class HttpHelper {
  static Future<void> handleUnauthorized(BuildContext context) async {
    await SessionManager.clear();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión expirada. Inicia sesión nuevamente.'),
      ),
    );
  }
}
