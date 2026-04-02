import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Product> _items = [];

  List<Product> get items => _items;
  int get count => _items.length;

  Future<void> fetchCart() async {
    try {
      final res = await _api.client.get('/cart');
      final List productsJson = res.data['products'];
      _items = productsJson.map((json) => Product.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching cart: $e");
    }
  }

  Future<void> addToCart(int productId) async {
    try {
      // POST to /api/rest/cart/add/{id}
      await _api.client.post('/cart/add/$productId');
      await fetchCart(); // Refresh local list and count
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeItem(int productId) async {
    await _api.client.delete('/cart/remove/$productId');
    await fetchCart();
  }
}