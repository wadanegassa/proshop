import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../core/constants/api_constants.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  final _storage = const FlutterSecureStorage();

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> fetchCart() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.cart),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> cartData = responseData['data']['items'];
        final Map<String, CartItemModel> loadedItems = {};
        for (var item in cartData) {
          final prod = ProductModel.fromJson(item['product']);
          loadedItems[prod.id] = CartItemModel(product: prod, quantity: item['quantity']);
        }
        _items = loadedItems;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }
  }

  Future<void> syncCart() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final cartData = _items.values.map((item) => {
        'product': item.product.id,
        'quantity': item.quantity
      }).toList();

      await http.post(
        Uri.parse(ApiConstants.cart),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'items': cartData}),
      );
    } catch (e) {
      debugPrint('Error syncing cart: $e');
    }
  }

  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItemModel(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(product: product),
      );
    }
    notifyListeners();
    syncCart();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
    syncCart();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItemModel(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
    syncCart();
  }

  void clear() {
    _items = {};
    notifyListeners();
    syncCart();
  }
}
