import 'package:flutter/material.dart';
import 'register_controller.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controller = RegisterController();

  @override
  void initState() {
    super.initState();
    _controller.init(context); // 🔴 OBLIGATORIO
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'GML',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'GLOBAL DE MAQUINARIA Y LUBRICANTES',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            _buildField(
              controller: _controller.emailController,
              label: 'Correo electrónico',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 12),

            _buildField(
              controller: _controller.nameController,
              label: 'Nombre',
              icon: Icons.person,
              keyboardType: TextInputType.name,
            ),


            const SizedBox(height: 12),

            _buildField(
              controller: _controller.lastNameController,
              label: 'Apellido',
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),


            const SizedBox(height: 12),

            _buildField(
              controller: _controller.phoneController,
              label: 'Teléfono',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 12),

            _buildField(
              controller: _controller.passwordController,
              label: 'Contraseña',
              icon: Icons.lock,
              obscure: true,
              keyboardType: TextInputType.visiblePassword,

            ),

            const SizedBox(height: 12),

            _buildField(
              controller: _controller.confirmPasswordController,
              label: 'Confirmar contraseña',
              icon: Icons.lock_outline,
              obscure: true,
              keyboardType: TextInputType.visiblePassword,

            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                ),
                child: const Text('Registrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      autocorrect: !obscure,
      enableSuggestions: !obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

