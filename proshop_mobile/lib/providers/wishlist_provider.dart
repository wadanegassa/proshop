import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';
import '../core/constants/api_constants.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> _wishlist = [];
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  List<ProductModel> get wishlist => [..._wishlist];
  bool get isLoading => _isLoading;

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.id == productId);
  }

  Future<void> fetchWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/auth/wishlist'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsData = data['data'];
        _wishlist = productsData.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    // Optimistic update
    if (isInWishlist(product.id)) return;
    
    _wishlist.add(product);
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/wishlist/${product.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      _wishlist.removeWhere((item) => item.id == product.id);
      notifyListeners();
      debugPrint('Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    // Optimistic update
    final index = _wishlist.indexWhere((item) => item.id == productId);
    if (index == -1) return;

    final removedItem = _wishlist[index];
    _wishlist.removeAt(index);
    notifyListeners();

    try {
      final token = await _storage.read(key: 'token');
      await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/auth/wishlist/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      _wishlist.insert(index, removedItem);
      notifyListeners();
      debugPrint('Error removing from wishlist: $e');
    }
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }
}
