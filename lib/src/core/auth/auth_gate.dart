import 'package:flutter/material.dart';
import '../storage/session_manager.dart';
import '../../features/auth/login_page.dart';
import '../../features/home/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SessionManager.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;

        if (token == null || token.isEmpty) {
          return const LoginPage();
        }

        return const HomePage();
      },
    );
  }
}
