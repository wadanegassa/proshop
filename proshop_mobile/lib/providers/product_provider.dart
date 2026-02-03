import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _products = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(ApiConstants.products))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsData = data['data']['products'];
        _allProducts = productsData.map((item) => ProductModel.fromJson(item)).toList();
        
        // Extract unique categories
        final Set<String> categorySet = {'All'};
        for (var product in _allProducts) {
          if (product.category.isNotEmpty) {
            categorySet.add(product.category);
          }
        }
        _categories = categorySet.toList()..sort();
        
        _applyFilter();
      }
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedCategory == 'All') {
      _products = _allProducts;
    } else {
      _products = _allProducts.where((p) => p.category == _selectedCategory).toList();
    }
  }

  Future<Map<String, dynamic>> addReview(String productId, int rating, String comment, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.products}/$productId/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'rating': rating,
          'comment': comment,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        // Refresh product data to get the new review and rating
        await fetchProducts();
        return {'success': true, 'message': 'Review added successfully'};
      }
      
      return {
        'success': false, 
        'message': data['message'] ?? 'Failed to submit review'
      };
    } catch (e) {
      print('Error adding review: $e');
      return {'success': false, 'message': 'Connection error. Please try again.'};
    }
  }
}
