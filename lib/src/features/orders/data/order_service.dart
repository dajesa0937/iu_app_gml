import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../../core/storage/session_manager.dart';
import '../domain/order_model.dart';

class OrderService {
  /// 🔹 Admin – obtener todos los pedidos
  Future<List<Order>> getAllOrders() async {
    final token = await SessionManager.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('ERROR_LOADING_ORDERS');
    }

    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => Order.fromJson(e)).toList();
  }

  /// 🔹 Admin – cambiar estado
  Future<void> updateStatus(String orderId, String status) async {
    final token = await SessionManager.getToken();

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/orders/$orderId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('ERROR_UPDATING_STATUS');
    }
  }
}
