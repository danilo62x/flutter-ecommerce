import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ecommerce/data/models/product_api_model.dart';

/// Stateless service wrapping the shop catalog HTTP endpoints.
class ShopApiService {
  ShopApiService({http.Client? client, this.baseUrl = 'https://api.example.com'})
      : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  /// GET the product catalog and decode it into transport models.
  Future<List<ProductApiModel>> fetchProducts() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/shop/products'),
      headers: const {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load products (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => ProductApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
