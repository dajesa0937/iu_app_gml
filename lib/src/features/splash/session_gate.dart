import 'package:flutter/material.dart';
import '../../core/storage/session_manager.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  bool _loading = true;
  bool _hasSession = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await SessionManager.getToken();

    if (!mounted) return;

    setState(() {
      _hasSession = token != null && token.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasSession) {
      return const LoginPage();
    }

    // 🔐 Usuario autenticado (cliente o admin)
    return const HomePage();
  }
}
