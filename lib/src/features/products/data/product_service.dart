import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../../core/storage/session_manager.dart';
import '../domain/product_model.dart';

class ProductService {
  /// 🔹 GET productos
  Future<List<Product>> getProducts() async {
    final response = await _authorizedGet('/products');

    if (response.statusCode != 200) {
      _handleErrors(response, fallback: 'ERROR_LOADING_PRODUCTS');
    }

    final decoded = jsonDecode(response.body);
    final List list = decoded['data'];
    return list.map((e) => Product.fromJson(e)).toList();
  }

  /// 🔹 CREATE producto (ADMIN)
  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
  }) async {
    await _authorizedPost(
      '/products',
      body: {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
      },
      successCode: 201,
      errorCode: 'ERROR_CREATING_PRODUCT',
    );
  }

  /// 🔹 UPDATE producto (ADMIN)
  Future<void> updateProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
  }) async {
    await _authorizedPut(
      '/products/$id',
      body: {
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'category': category,
      },
      errorCode: 'ERROR_UPDATING_PRODUCT',
    );
  }

  /// 🔹 DELETE producto (ADMIN)
  Future<void> deleteProduct(String id) async {
    await _authorizedDelete(
      '/products/$id',
      errorCode: 'ERROR_DELETING_PRODUCT',
    );
  }

  /* -------------------- HELPERS -------------------- */

  Future<http.Response> _authorizedGet(String path) async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(token),
    );

    return response;
  }

  Future<void> _authorizedPost(
      String path, {
        required Map<String, dynamic> body,
        required int successCode,
        required String errorCode,
      }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == successCode) return;
    _handleErrors(response, fallback: errorCode);
  }

  Future<void> _authorizedPut(
      String path, {
        required Map<String, dynamic> body,
        required String errorCode,
      }) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) return;
    _handleErrors(response, fallback: errorCode);
  }

  Future<void> _authorizedDelete(
      String path, {
        required String errorCode,
      }) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}$path'),
      headers: _headers(token),
    );

    if (response.statusCode == 200) return;
    _handleErrors(response, fallback: errorCode);
  }

  Future<String> _getToken() async {
    final token = await SessionManager.getToken();
    if (token == null) {
      throw Exception('SESSION_EXPIRED');
    }
    return token;
  }

  Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  void _handleErrors(http.Response response, {String? fallback}) {
    if (response.statusCode == 401) {
      throw Exception('SESSION_EXPIRED');
    }

    if (response.statusCode == 403) {
      throw Exception('FORBIDDEN');
    }

    throw Exception(fallback ?? 'UNEXPECTED_ERROR');
  }
}
