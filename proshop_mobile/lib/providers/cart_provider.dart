import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../core/constants/api_constants.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  final _storage = const FlutterSecureStorage();
  
  CartProvider() {
    _loadFromStorage();
  }

  Map<String, CartItemModel> get items => {..._items};

  List<CartItemModel> get selectedItems => _items.values.where((item) => item.isSelected).toList();

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      if (cartItem.isSelected) {
        total += cartItem.product.discountedPrice * cartItem.quantity;
      }
    });
    return total;
  }

  void toggleSelection(String key) {
    if (_items.containsKey(key)) {
      _items[key]!.isSelected = !_items[key]!.isSelected;
      _saveToStorage();
      notifyListeners();
    }
  }

  void selectOnly(String key) {
    _items.forEach((k, item) {
      item.isSelected = (k == key);
    });
    _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    try {
      final cartData = _items.map((key, value) => MapEntry(key, value.toJson()));
      await _storage.write(key: 'cart', value: json.encode(cartData));
    } catch (e) {
      debugPrint('Error saving cart to storage: $e');
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final cartDataString = await _storage.read(key: 'cart');
      if (cartDataString != null) {
        final Map<String, dynamic> decodedData = json.decode(cartDataString);
        final Map<String, CartItemModel> loadedItems = {};
        decodedData.forEach((key, value) {
          loadedItems[key] = CartItemModel.fromJson(value);
        });
        _items = loadedItems;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart from storage: $e');
    }
    // Also try to fetch from backend if logged in
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.cart),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> cartData = responseData['data']['items'];
        final Map<String, CartItemModel> loadedItems = {};
        for (var item in cartData) {
          final prod = ProductModel.fromJson(item['product']);
          final String size = item['size'] ?? '';
          final String color = item['color'] ?? '';
          final String shoeSize = item['shoeSize'] ?? '';
          final String key = '${prod.id}-$size-$color-$shoeSize';
          
          loadedItems[key] = CartItemModel(
            product: prod, 
            quantity: item['quantity'],
            selectedSize: size.isNotEmpty ? size : null,
            selectedColor: color.isNotEmpty ? color : null,
            selectedShoeSize: shoeSize.isNotEmpty ? shoeSize : null,
          );
        }
        _items = loadedItems;
        _saveToStorage();
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
        'quantity': item.quantity,
        'size': item.selectedSize ?? '',
        'color': item.selectedColor ?? '',
        'shoeSize': item.selectedShoeSize ?? ''
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

  void addItem(ProductModel product, {String? size, String? color, String? shoeSize}) {
    final String key = '${product.id}-${size ?? ''}-${color ?? ''}-${shoeSize ?? ''}';
    
    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existingItem) => CartItemModel(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
          selectedSize: existingItem.selectedSize,
          selectedColor: existingItem.selectedColor,
          selectedShoeSize: existingItem.selectedShoeSize,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItemModel(
          product: product,
          selectedSize: size,
          selectedColor: color,
          selectedShoeSize: shoeSize,
        ),
      );
    }
    _saveToStorage();
    notifyListeners();
    syncCart();
  }

  void removeItem(String key) {
    _items.remove(key);
    _saveToStorage();
    notifyListeners();
    syncCart();
  }

  void removeSingleItem(String key) {
    if (!_items.containsKey(key)) return;
    if (_items[key]!.quantity > 1) {
      _items.update(
        key,
        (existingItem) => CartItemModel(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
          selectedSize: existingItem.selectedSize,
          selectedColor: existingItem.selectedColor,
          selectedShoeSize: existingItem.selectedShoeSize,
        ),
      );
    } else {
      _items.remove(key);
    }
    _saveToStorage();
    notifyListeners();
    syncCart();
  }

  void clear() {
    _items = {};
    _saveToStorage();
    notifyListeners();
    syncCart();
  }

  void clearLocalOnly() {
    _items = {};
    _saveToStorage();
    notifyListeners();
  }
}
