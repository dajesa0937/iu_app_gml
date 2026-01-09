import 'package:flutter/material.dart';
import '../core/storage/session_manager.dart';
import 'data/login_service.dart';

class LoginController {
  late BuildContext context;
  final LoginService _service = LoginService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void init(BuildContext context) {
    this.context = context;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email y contraseña son obligatorios');
      return;
    }

    try {
      final result = await _service.login(
        email: email,
        password: password,
      );

      // ✅ GUARDAR SESIÓN (token + rol)
      await SessionManager.saveSession(
        token: result['token'],
        role: result['user']['role'],
      );


      if (!context.mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showMessage(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }

  void _showMessage(String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
