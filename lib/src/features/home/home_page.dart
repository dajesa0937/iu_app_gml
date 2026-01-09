import 'package:flutter/material.dart';
import '../../core/storage/session_manager.dart';
import '../auth/login_page.dart';
import '../products/presentation/product_list_page.dart';
import '../products/presentation/create_product_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global de Maquinaria y Lubricantes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
              onPressed: () async {
                await SessionManager.clear();
                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }

          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: SessionManager.getRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final role = snapshot.data ?? 'cliente';



            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a GML',
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 12),

                _roleBadge(role),

                const SizedBox(height: 30),

                // 🔹 Ver productos (todos)
                SizedBox(
                  width: 220,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.inventory),
                    label: const Text('Ver productos'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Botón solo admin
                if (role == 'admin')
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateProductPage(),
                          ),
                        );
                      },
                      child: const Text('+ Crear producto'),
                    ),

                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _roleBadge(String? role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: role == 'admin'
            ? Colors.red.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role == 'admin' ? 'Administrador' : 'Cliente',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: role == 'admin' ? Colors.red : Colors.blue,
        ),
      ),
    );
  }
}
