import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/api_config.dart';

class RegisterService {
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String lastName,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/users/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'lastName': lastName,
        'phone': phone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Error al registrar');
    }
  }
}
