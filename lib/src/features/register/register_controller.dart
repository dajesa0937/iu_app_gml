import 'package:flutter/material.dart';
import 'data/register_service.dart';

class RegisterController {
  late BuildContext context;
  final RegisterService _service = RegisterService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  void init(BuildContext context) {
    this.context = context;
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastName.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Todos los campos son obligatorios');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Las contraseñas no coinciden');
      return;
    }

    try {
      await _service.register(
        email: email,
        name: name,
        lastName: lastName,
        phone: phone,
        password: password,
      );

      _showMessage('Registro exitoso');

      // Volver al login después de registrar
      if (!context.mounted) return;

      Navigator.pop(context);

    } catch (e) {
      _showMessage(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  void _showMessage(String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  void dispose() {
    emailController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
