import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../../core/storage/session_manager.dart';
import '../domain/cart_item.dart';

class OrderService {
  Future<String> createOrder(List<CartItem> items) async {
    final token = await SessionManager.getToken();

    if (token == null) {
      throw Exception('SESSION_EXPIRED');
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'items': items.map((item) => {
          'productId': item.product.id,
          'quantity': item.quantity,
        }).toList(),
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['orderId'];
    }

    if (response.statusCode == 401) {
      throw Exception('SESSION_EXPIRED');
    }

    if (response.statusCode == 403) {
      throw Exception('FORBIDDEN');
    }

    throw Exception('ERROR_CREATING_ORDER');
  }
}
