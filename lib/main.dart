import 'package:flutter/material.dart';
import 'src/features/splash/session_gate.dart';
import 'src/features/auth/login_page.dart';
import 'src/features/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GmlApp());
}

class GmlApp extends StatelessWidget {
  const GmlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GML',
      theme: ThemeData(primarySwatch: Colors.green),

      // 👇 MUY IMPORTANTE
      initialRoute: '/',

      routes: {
        '/': (_) => const SessionGate(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
      },
    );
  }
}
